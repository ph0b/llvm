// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py UTC_ARGS: --version 2
// REQUIRES: riscv-registered-target
// RUN: %clang_cc1 -triple riscv64 -target-feature +v -target-feature +zfh \
// RUN:   -target-feature +experimental-zvfh -disable-O0-optnone  \
// RUN:   -emit-llvm %s -o - | opt -S -passes=mem2reg | \
// RUN:   FileCheck --check-prefix=CHECK-RV64 %s

#include <riscv_vector.h>

// CHECK-RV64-LABEL: define dso_local { <vscale x 2 x i32>, <vscale x 2 x i32> } @test_vloxseg2ei32_v_tuple_i32m1
// CHECK-RV64-SAME: (ptr noundef [[BASE:%.*]], <vscale x 2 x i32> [[BINDEX:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0:[0-9]+]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call { <vscale x 2 x i32>, <vscale x 2 x i32> } @llvm.riscv.vloxseg2.nxv2i32.nxv2i32.i64(<vscale x 2 x i32> poison, <vscale x 2 x i32> poison, ptr [[BASE]], <vscale x 2 x i32> [[BINDEX]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret { <vscale x 2 x i32>, <vscale x 2 x i32> } [[TMP0]]
//
vint32m1x2_t test_vloxseg2ei32_v_tuple_i32m1(const int32_t *base, vuint32m1_t bindex, size_t vl) {
  return __riscv_vloxseg2ei32_v_tuple_i32m1(base, bindex, vl);
}

// CHECK-RV64-LABEL: define dso_local { <vscale x 2 x i32>, <vscale x 2 x i32> } @test_vloxseg2ei32_v_tuple_i32m1_m
// CHECK-RV64-SAME: (<vscale x 2 x i1> [[MASK:%.*]], ptr noundef [[BASE:%.*]], <vscale x 2 x i32> [[BINDEX:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call { <vscale x 2 x i32>, <vscale x 2 x i32> } @llvm.riscv.vloxseg2.mask.nxv2i32.nxv2i32.i64(<vscale x 2 x i32> poison, <vscale x 2 x i32> poison, ptr [[BASE]], <vscale x 2 x i32> [[BINDEX]], <vscale x 2 x i1> [[MASK]], i64 [[VL]], i64 3)
// CHECK-RV64-NEXT:    ret { <vscale x 2 x i32>, <vscale x 2 x i32> } [[TMP0]]
//
vint32m1x2_t test_vloxseg2ei32_v_tuple_i32m1_m(vbool32_t mask, const int32_t *base, vuint32m1_t bindex, size_t vl) {
  return __riscv_vloxseg2ei32_v_tuple_i32m1_m(mask, base, bindex, vl);
}
