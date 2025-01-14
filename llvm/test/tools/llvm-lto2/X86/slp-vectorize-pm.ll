; RUN: opt -module-summary %s -o %t1.bc

; Test SLP and Loop Vectorization are enabled by default at O2 and O3.
; RUN: llvm-lto2 run -opaque-pointers %t1.bc -o %t2.o -O0 -r %t1.bc,foo,plx -debug-pass-manager \
; RUN:  -save-temps 2>&1 | FileCheck %s --check-prefix=CHECK-O0-SLP
; RUN: llvm-dis %t2.o.1.4.opt.bc -o - | FileCheck %s --check-prefix=CHECK-O0-LPV

; RUN: llvm-lto2 run -opaque-pointers %t1.bc -o %t3.o -O1 -r %t1.bc,foo,plx -debug-pass-manager \
; RUN:  -save-temps 2>&1 | FileCheck %s --check-prefix=CHECK-O1-SLP
; RUN: llvm-dis %t3.o.1.4.opt.bc -o - | FileCheck %s --check-prefix=CHECK-O1-LPV

; RUN: llvm-lto2 run -opaque-pointers %t1.bc -o %t4.o -O2 -r %t1.bc,foo,plx -debug-pass-manager \
; RUN:  -save-temps 2>&1 | FileCheck %s --check-prefix=CHECK-O2-SLP
; RUN: llvm-dis %t4.o.1.4.opt.bc -o - | FileCheck %s --check-prefix=CHECK-O2-LPV

; RUN: llvm-lto2 run -opaque-pointers %t1.bc -o %t5.o -O3 -r %t1.bc,foo,plx -debug-pass-manager \
; RUN:  -save-temps 2>&1 | FileCheck %s --check-prefix=CHECK-O3-SLP
; RUN: llvm-dis %t5.o.1.4.opt.bc -o - | FileCheck %s --check-prefix=CHECK-O3-LPV

; CHECK-O0-SLP-NOT: Running pass: SLPVectorizerPass
; CHECK-O1-SLP-NOT: Running pass: SLPVectorizerPass
; CHECK-O2-SLP: Running pass: SLPVectorizerPass
; CHECK-O3-SLP: Running pass: SLPVectorizerPass
; CHECK-O0-LPV-NOT: = !{!"llvm.loop.isvectorized", i32 1}
; CHECK-O1-LPV-NOT: = !{!"llvm.loop.isvectorized", i32 1}
; CHECK-O2-LPV: = !{!"llvm.loop.isvectorized", i32 1}
; CHECK-O3-LPV: = !{!"llvm.loop.isvectorized", i32 1}

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define i32 @foo(ptr %a) {
entry:
  br label %for.body

for.body:
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.body ]
  %red.05 = phi i32 [ 0, %entry ], [ %add, %for.body ]
  %arrayidx = getelementptr inbounds i32, ptr %a, i64 %indvars.iv
  %0 = load i32, ptr %arrayidx, align 4
  %add = add nsw i32 %0, %red.05
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond = icmp eq i64 %indvars.iv.next, 255
  br i1 %exitcond, label %for.end, label %for.body, !llvm.loop !0

for.end:
  ret i32 %add
}

!0 = distinct !{!0, !1}
!1 = !{!"llvm.loop.unroll.disable", i1 true}
