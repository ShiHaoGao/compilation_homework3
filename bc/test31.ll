; ModuleID = 'test31.bc'
source_filename = "test31.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.fptr = type { i32 (i32, i32)* }

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @plus(i32 %a, i32 %b) #0 !dbg !7 {
entry:
  %a.addr = alloca i32, align 4
  %b.addr = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %a.addr, metadata !11, metadata !DIExpression()), !dbg !12
  store i32 %b, i32* %b.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %b.addr, metadata !13, metadata !DIExpression()), !dbg !14
  %0 = load i32, i32* %a.addr, align 4, !dbg !15
  %1 = load i32, i32* %b.addr, align 4, !dbg !16
  %add = add nsw i32 %0, %1, !dbg !17
  ret i32 %add, !dbg !18
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @minus(i32 %a, i32 %b) #0 !dbg !19 {
entry:
  %a.addr = alloca i32, align 4
  %b.addr = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %a.addr, metadata !20, metadata !DIExpression()), !dbg !21
  store i32 %b, i32* %b.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %b.addr, metadata !22, metadata !DIExpression()), !dbg !23
  %0 = load i32, i32* %a.addr, align 4, !dbg !24
  %1 = load i32, i32* %b.addr, align 4, !dbg !25
  %sub = sub nsw i32 %0, %1, !dbg !26
  ret i32 %sub, !dbg !27
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 (i32, i32)* @foo(i32 %a, i32 %b, %struct.fptr* %c_fptr, %struct.fptr* %d_fptr) #0 !dbg !28 {
entry:
  %a.addr = alloca i32, align 4
  %b.addr = alloca i32, align 4
  %c_fptr.addr = alloca %struct.fptr*, align 8
  %d_fptr.addr = alloca %struct.fptr*, align 8
  store i32 %a, i32* %a.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %a.addr, metadata !36, metadata !DIExpression()), !dbg !37
  store i32 %b, i32* %b.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %b.addr, metadata !38, metadata !DIExpression()), !dbg !39
  store %struct.fptr* %c_fptr, %struct.fptr** %c_fptr.addr, align 8
  call void @llvm.dbg.declare(metadata %struct.fptr** %c_fptr.addr, metadata !40, metadata !DIExpression()), !dbg !41
  store %struct.fptr* %d_fptr, %struct.fptr** %d_fptr.addr, align 8
  call void @llvm.dbg.declare(metadata %struct.fptr** %d_fptr.addr, metadata !42, metadata !DIExpression()), !dbg !43
  %0 = load %struct.fptr*, %struct.fptr** %c_fptr.addr, align 8, !dbg !44
  %p_fptr = getelementptr inbounds %struct.fptr, %struct.fptr* %0, i32 0, i32 0, !dbg !45
  %1 = load i32 (i32, i32)*, i32 (i32, i32)** %p_fptr, align 8, !dbg !45
  ret i32 (i32, i32)* %1, !dbg !46
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 (i32, i32)* @clever(i32 %a, i32 %b, %struct.fptr* %c_fptr, %struct.fptr* %d_fptr) #0 !dbg !47 {
entry:
  %retval = alloca i32 (i32, i32)*, align 8
  %a.addr = alloca i32, align 4
  %b.addr = alloca i32, align 4
  %c_fptr.addr = alloca %struct.fptr*, align 8
  %d_fptr.addr = alloca %struct.fptr*, align 8
  store i32 %a, i32* %a.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %a.addr, metadata !48, metadata !DIExpression()), !dbg !49
  store i32 %b, i32* %b.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %b.addr, metadata !50, metadata !DIExpression()), !dbg !51
  store %struct.fptr* %c_fptr, %struct.fptr** %c_fptr.addr, align 8
  call void @llvm.dbg.declare(metadata %struct.fptr** %c_fptr.addr, metadata !52, metadata !DIExpression()), !dbg !53
  store %struct.fptr* %d_fptr, %struct.fptr** %d_fptr.addr, align 8
  call void @llvm.dbg.declare(metadata %struct.fptr** %d_fptr.addr, metadata !54, metadata !DIExpression()), !dbg !55
  %0 = load i32, i32* %a.addr, align 4, !dbg !56
  %cmp = icmp sgt i32 %0, 0, !dbg !58
  br i1 %cmp, label %land.lhs.true, label %if.end, !dbg !59

land.lhs.true:                                    ; preds = %entry
  %1 = load i32, i32* %b.addr, align 4, !dbg !60
  %cmp1 = icmp slt i32 %1, 0, !dbg !61
  br i1 %cmp1, label %if.then, label %if.end, !dbg !62

if.then:                                          ; preds = %land.lhs.true
  %2 = load %struct.fptr*, %struct.fptr** %d_fptr.addr, align 8, !dbg !63
  %p_fptr = getelementptr inbounds %struct.fptr, %struct.fptr* %2, i32 0, i32 0, !dbg !65
  %3 = load i32 (i32, i32)*, i32 (i32, i32)** %p_fptr, align 8, !dbg !65
  store i32 (i32, i32)* %3, i32 (i32, i32)** %retval, align 8, !dbg !66
  br label %return, !dbg !66

if.end:                                           ; preds = %land.lhs.true, %entry
  %4 = load %struct.fptr*, %struct.fptr** %c_fptr.addr, align 8, !dbg !67
  %p_fptr2 = getelementptr inbounds %struct.fptr, %struct.fptr* %4, i32 0, i32 0, !dbg !68
  %5 = load i32 (i32, i32)*, i32 (i32, i32)** %p_fptr2, align 8, !dbg !68
  store i32 (i32, i32)* %5, i32 (i32, i32)** %retval, align 8, !dbg !69
  br label %return, !dbg !69

return:                                           ; preds = %if.end, %if.then
  %6 = load i32 (i32, i32)*, i32 (i32, i32)** %retval, align 8, !dbg !70
  ret i32 (i32, i32)* %6, !dbg !70
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @moo(i8 signext %x, i32 %op1, i32 %op2) #0 !dbg !71 {
entry:
  %x.addr = alloca i8, align 1
  %op1.addr = alloca i32, align 4
  %op2.addr = alloca i32, align 4
  %a_fptr = alloca %struct.fptr, align 8
  %s_fptr = alloca %struct.fptr, align 8
  %goo_ptr = alloca i32 (i32, i32)* (i32, i32, %struct.fptr*, %struct.fptr*)*, align 8
  %t_fptr = alloca i32 (i32, i32)*, align 8
  store i8 %x, i8* %x.addr, align 1
  call void @llvm.dbg.declare(metadata i8* %x.addr, metadata !75, metadata !DIExpression()), !dbg !76
  store i32 %op1, i32* %op1.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %op1.addr, metadata !77, metadata !DIExpression()), !dbg !78
  store i32 %op2, i32* %op2.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %op2.addr, metadata !79, metadata !DIExpression()), !dbg !80
  call void @llvm.dbg.declare(metadata %struct.fptr* %a_fptr, metadata !81, metadata !DIExpression()), !dbg !82
  %p_fptr = getelementptr inbounds %struct.fptr, %struct.fptr* %a_fptr, i32 0, i32 0, !dbg !83
  store i32 (i32, i32)* @plus, i32 (i32, i32)** %p_fptr, align 8, !dbg !84
  call void @llvm.dbg.declare(metadata %struct.fptr* %s_fptr, metadata !85, metadata !DIExpression()), !dbg !86
  %p_fptr1 = getelementptr inbounds %struct.fptr, %struct.fptr* %s_fptr, i32 0, i32 0, !dbg !87
  store i32 (i32, i32)* @minus, i32 (i32, i32)** %p_fptr1, align 8, !dbg !88
  call void @llvm.dbg.declare(metadata i32 (i32, i32)* (i32, i32, %struct.fptr*, %struct.fptr*)** %goo_ptr, metadata !89, metadata !DIExpression()), !dbg !91
  store i32 (i32, i32)* (i32, i32, %struct.fptr*, %struct.fptr*)* @foo, i32 (i32, i32)* (i32, i32, %struct.fptr*, %struct.fptr*)** %goo_ptr, align 8, !dbg !91
  call void @llvm.dbg.declare(metadata i32 (i32, i32)** %t_fptr, metadata !92, metadata !DIExpression()), !dbg !93
  store i32 (i32, i32)* null, i32 (i32, i32)** %t_fptr, align 8, !dbg !93
  %0 = load i8, i8* %x.addr, align 1, !dbg !94
  %conv = sext i8 %0 to i32, !dbg !94
  %cmp = icmp eq i32 %conv, 43, !dbg !96
  br i1 %cmp, label %if.then, label %if.else, !dbg !97

if.then:                                          ; preds = %entry
  %1 = load i32 (i32, i32)* (i32, i32, %struct.fptr*, %struct.fptr*)*, i32 (i32, i32)* (i32, i32, %struct.fptr*, %struct.fptr*)** %goo_ptr, align 8, !dbg !98
  %2 = load i32, i32* %op1.addr, align 4, !dbg !100
  %3 = load i32, i32* %op2.addr, align 4, !dbg !101
  %call = call i32 (i32, i32)* %1(i32 %2, i32 %3, %struct.fptr* %a_fptr, %struct.fptr* %s_fptr), !dbg !98
  store i32 (i32, i32)* %call, i32 (i32, i32)** %t_fptr, align 8, !dbg !102
  %4 = load i32 (i32, i32)*, i32 (i32, i32)** %t_fptr, align 8, !dbg !103
  %5 = load i32, i32* %op1.addr, align 4, !dbg !104
  %6 = load i32, i32* %op2.addr, align 4, !dbg !105
  %call3 = call i32 %4(i32 %5, i32 %6), !dbg !103
  br label %if.end, !dbg !106

if.else:                                          ; preds = %entry
  store i32 (i32, i32)* (i32, i32, %struct.fptr*, %struct.fptr*)* @clever, i32 (i32, i32)* (i32, i32, %struct.fptr*, %struct.fptr*)** %goo_ptr, align 8, !dbg !107
  %7 = load i32 (i32, i32)* (i32, i32, %struct.fptr*, %struct.fptr*)*, i32 (i32, i32)* (i32, i32, %struct.fptr*, %struct.fptr*)** %goo_ptr, align 8, !dbg !109
  %8 = load i32, i32* %op1.addr, align 4, !dbg !110
  %9 = load i32, i32* %op2.addr, align 4, !dbg !111
  %call4 = call i32 (i32, i32)* %7(i32 %8, i32 %9, %struct.fptr* %s_fptr, %struct.fptr* %a_fptr), !dbg !109
  store i32 (i32, i32)* %call4, i32 (i32, i32)** %t_fptr, align 8, !dbg !112
  %10 = load i32 (i32, i32)*, i32 (i32, i32)** %t_fptr, align 8, !dbg !113
  %11 = load i32, i32* %op1.addr, align 4, !dbg !114
  %12 = load i32, i32* %op2.addr, align 4, !dbg !115
  %call5 = call i32 %10(i32 %11, i32 %12), !dbg !113
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %13 = load i32 (i32, i32)*, i32 (i32, i32)** %t_fptr, align 8, !dbg !116
  %14 = load i32, i32* %op1.addr, align 4, !dbg !117
  %15 = load i32, i32* %op2.addr, align 4, !dbg !118
  %call6 = call i32 %13(i32 %14, i32 %15), !dbg !116
  ret i32 0, !dbg !119
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 10.0.0 ", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "test31.c", directory: "/root/hw3/assign3/tests")
!2 = !{}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"clang version 10.0.0 "}
!7 = distinct !DISubprogram(name: "plus", scope: !1, file: !1, line: 7, type: !8, scopeLine: 7, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10, !10, !10}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DILocalVariable(name: "a", arg: 1, scope: !7, file: !1, line: 7, type: !10)
!12 = !DILocation(line: 7, column: 14, scope: !7)
!13 = !DILocalVariable(name: "b", arg: 2, scope: !7, file: !1, line: 7, type: !10)
!14 = !DILocation(line: 7, column: 21, scope: !7)
!15 = !DILocation(line: 8, column: 11, scope: !7)
!16 = !DILocation(line: 8, column: 13, scope: !7)
!17 = !DILocation(line: 8, column: 12, scope: !7)
!18 = !DILocation(line: 8, column: 4, scope: !7)
!19 = distinct !DISubprogram(name: "minus", scope: !1, file: !1, line: 11, type: !8, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!20 = !DILocalVariable(name: "a", arg: 1, scope: !19, file: !1, line: 11, type: !10)
!21 = !DILocation(line: 11, column: 15, scope: !19)
!22 = !DILocalVariable(name: "b", arg: 2, scope: !19, file: !1, line: 11, type: !10)
!23 = !DILocation(line: 11, column: 22, scope: !19)
!24 = !DILocation(line: 12, column: 11, scope: !19)
!25 = !DILocation(line: 12, column: 13, scope: !19)
!26 = !DILocation(line: 12, column: 12, scope: !19)
!27 = !DILocation(line: 12, column: 4, scope: !19)
!28 = distinct !DISubprogram(name: "foo", scope: !1, file: !1, line: 15, type: !29, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!29 = !DISubroutineType(types: !30)
!30 = !{!31, !10, !10, !32, !32}
!31 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !8, size: 64)
!32 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !33, size: 64)
!33 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "fptr", file: !1, line: 2, size: 64, elements: !34)
!34 = !{!35}
!35 = !DIDerivedType(tag: DW_TAG_member, name: "p_fptr", scope: !33, file: !1, line: 4, baseType: !31, size: 64)
!36 = !DILocalVariable(name: "a", arg: 1, scope: !28, file: !1, line: 15, type: !10)
!37 = !DILocation(line: 15, column: 15, scope: !28)
!38 = !DILocalVariable(name: "b", arg: 2, scope: !28, file: !1, line: 15, type: !10)
!39 = !DILocation(line: 15, column: 22, scope: !28)
!40 = !DILocalVariable(name: "c_fptr", arg: 3, scope: !28, file: !1, line: 15, type: !32)
!41 = !DILocation(line: 15, column: 39, scope: !28)
!42 = !DILocalVariable(name: "d_fptr", arg: 4, scope: !28, file: !1, line: 15, type: !32)
!43 = !DILocation(line: 15, column: 61, scope: !28)
!44 = !DILocation(line: 16, column: 11, scope: !28)
!45 = !DILocation(line: 16, column: 19, scope: !28)
!46 = !DILocation(line: 16, column: 4, scope: !28)
!47 = distinct !DISubprogram(name: "clever", scope: !1, file: !1, line: 19, type: !29, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!48 = !DILocalVariable(name: "a", arg: 1, scope: !47, file: !1, line: 19, type: !10)
!49 = !DILocation(line: 19, column: 18, scope: !47)
!50 = !DILocalVariable(name: "b", arg: 2, scope: !47, file: !1, line: 19, type: !10)
!51 = !DILocation(line: 19, column: 25, scope: !47)
!52 = !DILocalVariable(name: "c_fptr", arg: 3, scope: !47, file: !1, line: 19, type: !32)
!53 = !DILocation(line: 19, column: 42, scope: !47)
!54 = !DILocalVariable(name: "d_fptr", arg: 4, scope: !47, file: !1, line: 19, type: !32)
!55 = !DILocation(line: 19, column: 64, scope: !47)
!56 = !DILocation(line: 20, column: 6, scope: !57)
!57 = distinct !DILexicalBlock(scope: !47, file: !1, line: 20, column: 6)
!58 = !DILocation(line: 20, column: 7, scope: !57)
!59 = !DILocation(line: 20, column: 10, scope: !57)
!60 = !DILocation(line: 20, column: 13, scope: !57)
!61 = !DILocation(line: 20, column: 14, scope: !57)
!62 = !DILocation(line: 20, column: 6, scope: !47)
!63 = !DILocation(line: 22, column: 11, scope: !64)
!64 = distinct !DILexicalBlock(scope: !57, file: !1, line: 21, column: 3)
!65 = !DILocation(line: 22, column: 19, scope: !64)
!66 = !DILocation(line: 22, column: 4, scope: !64)
!67 = !DILocation(line: 25, column: 10, scope: !47)
!68 = !DILocation(line: 25, column: 18, scope: !47)
!69 = !DILocation(line: 25, column: 3, scope: !47)
!70 = !DILocation(line: 26, column: 1, scope: !47)
!71 = distinct !DISubprogram(name: "moo", scope: !1, file: !1, line: 28, type: !72, scopeLine: 28, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!72 = !DISubroutineType(types: !73)
!73 = !{!10, !74, !10, !10}
!74 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!75 = !DILocalVariable(name: "x", arg: 1, scope: !71, file: !1, line: 28, type: !74)
!76 = !DILocation(line: 28, column: 14, scope: !71)
!77 = !DILocalVariable(name: "op1", arg: 2, scope: !71, file: !1, line: 28, type: !10)
!78 = !DILocation(line: 28, column: 21, scope: !71)
!79 = !DILocalVariable(name: "op2", arg: 3, scope: !71, file: !1, line: 28, type: !10)
!80 = !DILocation(line: 28, column: 30, scope: !71)
!81 = !DILocalVariable(name: "a_fptr", scope: !71, file: !1, line: 29, type: !33)
!82 = !DILocation(line: 29, column: 17, scope: !71)
!83 = !DILocation(line: 30, column: 12, scope: !71)
!84 = !DILocation(line: 30, column: 18, scope: !71)
!85 = !DILocalVariable(name: "s_fptr", scope: !71, file: !1, line: 31, type: !33)
!86 = !DILocation(line: 31, column: 17, scope: !71)
!87 = !DILocation(line: 32, column: 12, scope: !71)
!88 = !DILocation(line: 32, column: 18, scope: !71)
!89 = !DILocalVariable(name: "goo_ptr", scope: !71, file: !1, line: 34, type: !90)
!90 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !29, size: 64)
!91 = !DILocation(line: 34, column: 14, scope: !71)
!92 = !DILocalVariable(name: "t_fptr", scope: !71, file: !1, line: 35, type: !31)
!93 = !DILocation(line: 35, column: 11, scope: !71)
!94 = !DILocation(line: 37, column: 8, scope: !95)
!95 = distinct !DILexicalBlock(scope: !71, file: !1, line: 37, column: 8)
!96 = !DILocation(line: 37, column: 10, scope: !95)
!97 = !DILocation(line: 37, column: 8, scope: !71)
!98 = !DILocation(line: 39, column: 18, scope: !99)
!99 = distinct !DILexicalBlock(scope: !95, file: !1, line: 38, column: 5)
!100 = !DILocation(line: 39, column: 26, scope: !99)
!101 = !DILocation(line: 39, column: 31, scope: !99)
!102 = !DILocation(line: 39, column: 16, scope: !99)
!103 = !DILocation(line: 40, column: 9, scope: !99)
!104 = !DILocation(line: 40, column: 16, scope: !99)
!105 = !DILocation(line: 40, column: 21, scope: !99)
!106 = !DILocation(line: 41, column: 5, scope: !99)
!107 = !DILocation(line: 43, column: 16, scope: !108)
!108 = distinct !DILexicalBlock(scope: !95, file: !1, line: 42, column: 5)
!109 = !DILocation(line: 44, column: 18, scope: !108)
!110 = !DILocation(line: 44, column: 26, scope: !108)
!111 = !DILocation(line: 44, column: 31, scope: !108)
!112 = !DILocation(line: 44, column: 16, scope: !108)
!113 = !DILocation(line: 45, column: 9, scope: !108)
!114 = !DILocation(line: 45, column: 16, scope: !108)
!115 = !DILocation(line: 45, column: 21, scope: !108)
!116 = !DILocation(line: 47, column: 5, scope: !71)
!117 = !DILocation(line: 47, column: 12, scope: !71)
!118 = !DILocation(line: 47, column: 17, scope: !71)
!119 = !DILocation(line: 48, column: 5, scope: !71)
