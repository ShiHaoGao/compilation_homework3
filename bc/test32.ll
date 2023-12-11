; ModuleID = 'test32.bc'
source_filename = "test32.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.fptr = type { i32 (i32, i32)* }
%struct.wfsptr = type { %struct.fsptr* }
%struct.fsptr = type { %struct.fptr* }

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
define dso_local %struct.fptr* @foo(i32 %a, i32 %b, %struct.wfsptr* %a_fptr, %struct.wfsptr* %b_fptr) #0 !dbg !28 {
entry:
  %retval = alloca %struct.fptr*, align 8
  %a.addr = alloca i32, align 4
  %b.addr = alloca i32, align 4
  %a_fptr.addr = alloca %struct.wfsptr*, align 8
  %b_fptr.addr = alloca %struct.wfsptr*, align 8
  %temp = alloca %struct.fsptr*, align 8
  store i32 %a, i32* %a.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %a.addr, metadata !44, metadata !DIExpression()), !dbg !45
  store i32 %b, i32* %b.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %b.addr, metadata !46, metadata !DIExpression()), !dbg !47
  store %struct.wfsptr* %a_fptr, %struct.wfsptr** %a_fptr.addr, align 8
  call void @llvm.dbg.declare(metadata %struct.wfsptr** %a_fptr.addr, metadata !48, metadata !DIExpression()), !dbg !49
  store %struct.wfsptr* %b_fptr, %struct.wfsptr** %b_fptr.addr, align 8
  call void @llvm.dbg.declare(metadata %struct.wfsptr** %b_fptr.addr, metadata !50, metadata !DIExpression()), !dbg !51
  %0 = load i32, i32* %a.addr, align 4, !dbg !52
  %cmp = icmp sgt i32 %0, 0, !dbg !54
  br i1 %cmp, label %land.lhs.true, label %if.end, !dbg !55

land.lhs.true:                                    ; preds = %entry
  %1 = load i32, i32* %b.addr, align 4, !dbg !56
  %cmp1 = icmp slt i32 %1, 0, !dbg !57
  br i1 %cmp1, label %if.then, label %if.end, !dbg !58

if.then:                                          ; preds = %land.lhs.true
  call void @llvm.dbg.declare(metadata %struct.fsptr** %temp, metadata !59, metadata !DIExpression()), !dbg !61
  %2 = load %struct.wfsptr*, %struct.wfsptr** %a_fptr.addr, align 8, !dbg !62
  %wfptr = getelementptr inbounds %struct.wfsptr, %struct.wfsptr* %2, i32 0, i32 0, !dbg !63
  %3 = load %struct.fsptr*, %struct.fsptr** %wfptr, align 8, !dbg !63
  store %struct.fsptr* %3, %struct.fsptr** %temp, align 8, !dbg !61
  %4 = load %struct.wfsptr*, %struct.wfsptr** %b_fptr.addr, align 8, !dbg !64
  %wfptr2 = getelementptr inbounds %struct.wfsptr, %struct.wfsptr* %4, i32 0, i32 0, !dbg !65
  %5 = load %struct.fsptr*, %struct.fsptr** %wfptr2, align 8, !dbg !65
  %sptr = getelementptr inbounds %struct.fsptr, %struct.fsptr* %5, i32 0, i32 0, !dbg !66
  %6 = load %struct.fptr*, %struct.fptr** %sptr, align 8, !dbg !66
  %7 = load %struct.wfsptr*, %struct.wfsptr** %a_fptr.addr, align 8, !dbg !67
  %wfptr3 = getelementptr inbounds %struct.wfsptr, %struct.wfsptr* %7, i32 0, i32 0, !dbg !68
  %8 = load %struct.fsptr*, %struct.fsptr** %wfptr3, align 8, !dbg !68
  %sptr4 = getelementptr inbounds %struct.fsptr, %struct.fsptr* %8, i32 0, i32 0, !dbg !69
  store %struct.fptr* %6, %struct.fptr** %sptr4, align 8, !dbg !70
  %9 = load %struct.fsptr*, %struct.fsptr** %temp, align 8, !dbg !71
  %sptr5 = getelementptr inbounds %struct.fsptr, %struct.fsptr* %9, i32 0, i32 0, !dbg !72
  %10 = load %struct.fptr*, %struct.fptr** %sptr5, align 8, !dbg !72
  %11 = load %struct.wfsptr*, %struct.wfsptr** %b_fptr.addr, align 8, !dbg !73
  %wfptr6 = getelementptr inbounds %struct.wfsptr, %struct.wfsptr* %11, i32 0, i32 0, !dbg !74
  %12 = load %struct.fsptr*, %struct.fsptr** %wfptr6, align 8, !dbg !74
  %sptr7 = getelementptr inbounds %struct.fsptr, %struct.fsptr* %12, i32 0, i32 0, !dbg !75
  store %struct.fptr* %10, %struct.fptr** %sptr7, align 8, !dbg !76
  %13 = load %struct.wfsptr*, %struct.wfsptr** %a_fptr.addr, align 8, !dbg !77
  %wfptr8 = getelementptr inbounds %struct.wfsptr, %struct.wfsptr* %13, i32 0, i32 0, !dbg !78
  %14 = load %struct.fsptr*, %struct.fsptr** %wfptr8, align 8, !dbg !78
  %sptr9 = getelementptr inbounds %struct.fsptr, %struct.fsptr* %14, i32 0, i32 0, !dbg !79
  %15 = load %struct.fptr*, %struct.fptr** %sptr9, align 8, !dbg !79
  store %struct.fptr* %15, %struct.fptr** %retval, align 8, !dbg !80
  br label %return, !dbg !80

if.end:                                           ; preds = %land.lhs.true, %entry
  %16 = load %struct.wfsptr*, %struct.wfsptr** %b_fptr.addr, align 8, !dbg !81
  %wfptr10 = getelementptr inbounds %struct.wfsptr, %struct.wfsptr* %16, i32 0, i32 0, !dbg !82
  %17 = load %struct.fsptr*, %struct.fsptr** %wfptr10, align 8, !dbg !82
  %sptr11 = getelementptr inbounds %struct.fsptr, %struct.fsptr* %17, i32 0, i32 0, !dbg !83
  %18 = load %struct.fptr*, %struct.fptr** %sptr11, align 8, !dbg !83
  store %struct.fptr* %18, %struct.fptr** %retval, align 8, !dbg !84
  br label %return, !dbg !84

return:                                           ; preds = %if.end, %if.then
  %19 = load %struct.fptr*, %struct.fptr** %retval, align 8, !dbg !85
  ret %struct.fptr* %19, !dbg !85
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local %struct.fptr* @clever(i32 %a, i32 %b, %struct.fsptr* %a_fptr, %struct.fsptr* %b_fptr) #0 !dbg !86 {
entry:
  %a.addr = alloca i32, align 4
  %b.addr = alloca i32, align 4
  %a_fptr.addr = alloca %struct.fsptr*, align 8
  %b_fptr.addr = alloca %struct.fsptr*, align 8
  %t1_fptr = alloca %struct.wfsptr, align 8
  %t2_fptr = alloca %struct.wfsptr, align 8
  store i32 %a, i32* %a.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %a.addr, metadata !89, metadata !DIExpression()), !dbg !90
  store i32 %b, i32* %b.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %b.addr, metadata !91, metadata !DIExpression()), !dbg !92
  store %struct.fsptr* %a_fptr, %struct.fsptr** %a_fptr.addr, align 8
  call void @llvm.dbg.declare(metadata %struct.fsptr** %a_fptr.addr, metadata !93, metadata !DIExpression()), !dbg !94
  store %struct.fsptr* %b_fptr, %struct.fsptr** %b_fptr.addr, align 8
  call void @llvm.dbg.declare(metadata %struct.fsptr** %b_fptr.addr, metadata !95, metadata !DIExpression()), !dbg !96
  call void @llvm.dbg.declare(metadata %struct.wfsptr* %t1_fptr, metadata !97, metadata !DIExpression()), !dbg !98
  %0 = load %struct.fsptr*, %struct.fsptr** %a_fptr.addr, align 8, !dbg !99
  %wfptr = getelementptr inbounds %struct.wfsptr, %struct.wfsptr* %t1_fptr, i32 0, i32 0, !dbg !100
  store %struct.fsptr* %0, %struct.fsptr** %wfptr, align 8, !dbg !101
  call void @llvm.dbg.declare(metadata %struct.wfsptr* %t2_fptr, metadata !102, metadata !DIExpression()), !dbg !103
  %1 = load %struct.fsptr*, %struct.fsptr** %b_fptr.addr, align 8, !dbg !104
  %wfptr1 = getelementptr inbounds %struct.wfsptr, %struct.wfsptr* %t2_fptr, i32 0, i32 0, !dbg !105
  store %struct.fsptr* %1, %struct.fsptr** %wfptr1, align 8, !dbg !106
  %2 = load i32, i32* %a.addr, align 4, !dbg !107
  %3 = load i32, i32* %b.addr, align 4, !dbg !108
  %call = call %struct.fptr* @foo(i32 %2, i32 %3, %struct.wfsptr* %t1_fptr, %struct.wfsptr* %t2_fptr), !dbg !109
  ret %struct.fptr* %call, !dbg !110
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @moo(i8 signext %x, i32 %op1, i32 %op2) #0 !dbg !111 {
entry:
  %x.addr = alloca i8, align 1
  %op1.addr = alloca i32, align 4
  %op2.addr = alloca i32, align 4
  %a_fptr = alloca %struct.fptr, align 8
  %s_fptr = alloca %struct.fptr, align 8
  %m_fptr = alloca %struct.fsptr, align 8
  %n_fptr = alloca %struct.fsptr, align 8
  %goo_ptr = alloca %struct.fptr* (i32, i32, %struct.fsptr*, %struct.fsptr*)*, align 8
  %t_fptr = alloca %struct.fptr*, align 8
  store i8 %x, i8* %x.addr, align 1
  call void @llvm.dbg.declare(metadata i8* %x.addr, metadata !115, metadata !DIExpression()), !dbg !116
  store i32 %op1, i32* %op1.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %op1.addr, metadata !117, metadata !DIExpression()), !dbg !118
  store i32 %op2, i32* %op2.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %op2.addr, metadata !119, metadata !DIExpression()), !dbg !120
  call void @llvm.dbg.declare(metadata %struct.fptr* %a_fptr, metadata !121, metadata !DIExpression()), !dbg !122
  %p_fptr = getelementptr inbounds %struct.fptr, %struct.fptr* %a_fptr, i32 0, i32 0, !dbg !123
  store i32 (i32, i32)* @plus, i32 (i32, i32)** %p_fptr, align 8, !dbg !124
  call void @llvm.dbg.declare(metadata %struct.fptr* %s_fptr, metadata !125, metadata !DIExpression()), !dbg !126
  %p_fptr1 = getelementptr inbounds %struct.fptr, %struct.fptr* %s_fptr, i32 0, i32 0, !dbg !127
  store i32 (i32, i32)* @minus, i32 (i32, i32)** %p_fptr1, align 8, !dbg !128
  call void @llvm.dbg.declare(metadata %struct.fsptr* %m_fptr, metadata !129, metadata !DIExpression()), !dbg !130
  %sptr = getelementptr inbounds %struct.fsptr, %struct.fsptr* %m_fptr, i32 0, i32 0, !dbg !131
  store %struct.fptr* %a_fptr, %struct.fptr** %sptr, align 8, !dbg !132
  call void @llvm.dbg.declare(metadata %struct.fsptr* %n_fptr, metadata !133, metadata !DIExpression()), !dbg !134
  %sptr2 = getelementptr inbounds %struct.fsptr, %struct.fsptr* %n_fptr, i32 0, i32 0, !dbg !135
  store %struct.fptr* %s_fptr, %struct.fptr** %sptr2, align 8, !dbg !136
  call void @llvm.dbg.declare(metadata %struct.fptr* (i32, i32, %struct.fsptr*, %struct.fsptr*)** %goo_ptr, metadata !137, metadata !DIExpression()), !dbg !139
  call void @llvm.dbg.declare(metadata %struct.fptr** %t_fptr, metadata !140, metadata !DIExpression()), !dbg !141
  store %struct.fptr* null, %struct.fptr** %t_fptr, align 8, !dbg !141
  %0 = load i32, i32* %op1.addr, align 4, !dbg !142
  %1 = load i32, i32* %op2.addr, align 4, !dbg !143
  %call = call %struct.fptr* @clever(i32 %0, i32 %1, %struct.fsptr* %m_fptr, %struct.fsptr* %n_fptr), !dbg !144
  store %struct.fptr* %call, %struct.fptr** %t_fptr, align 8, !dbg !145
  %2 = load %struct.fptr*, %struct.fptr** %t_fptr, align 8, !dbg !146
  %p_fptr3 = getelementptr inbounds %struct.fptr, %struct.fptr* %2, i32 0, i32 0, !dbg !147
  %3 = load i32 (i32, i32)*, i32 (i32, i32)** %p_fptr3, align 8, !dbg !147
  %4 = load i32, i32* %op1.addr, align 4, !dbg !148
  %5 = load i32, i32* %op2.addr, align 4, !dbg !149
  %call4 = call i32 %3(i32 %4, i32 %5), !dbg !146
  %sptr5 = getelementptr inbounds %struct.fsptr, %struct.fsptr* %n_fptr, i32 0, i32 0, !dbg !150
  %6 = load %struct.fptr*, %struct.fptr** %sptr5, align 8, !dbg !150
  %p_fptr6 = getelementptr inbounds %struct.fptr, %struct.fptr* %6, i32 0, i32 0, !dbg !151
  %7 = load i32 (i32, i32)*, i32 (i32, i32)** %p_fptr6, align 8, !dbg !151
  %8 = load i32, i32* %op1.addr, align 4, !dbg !152
  %9 = load i32, i32* %op2.addr, align 4, !dbg !153
  %call7 = call i32 %7(i32 %8, i32 %9), !dbg !154
  ret i32 0, !dbg !155
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 10.0.0 ", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "test32.c", directory: "/root/hw3/assign3/tests")
!2 = !{}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"clang version 10.0.0 "}
!7 = distinct !DISubprogram(name: "plus", scope: !1, file: !1, line: 14, type: !8, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10, !10, !10}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DILocalVariable(name: "a", arg: 1, scope: !7, file: !1, line: 14, type: !10)
!12 = !DILocation(line: 14, column: 14, scope: !7)
!13 = !DILocalVariable(name: "b", arg: 2, scope: !7, file: !1, line: 14, type: !10)
!14 = !DILocation(line: 14, column: 21, scope: !7)
!15 = !DILocation(line: 15, column: 11, scope: !7)
!16 = !DILocation(line: 15, column: 13, scope: !7)
!17 = !DILocation(line: 15, column: 12, scope: !7)
!18 = !DILocation(line: 15, column: 4, scope: !7)
!19 = distinct !DISubprogram(name: "minus", scope: !1, file: !1, line: 18, type: !8, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!20 = !DILocalVariable(name: "a", arg: 1, scope: !19, file: !1, line: 18, type: !10)
!21 = !DILocation(line: 18, column: 15, scope: !19)
!22 = !DILocalVariable(name: "b", arg: 2, scope: !19, file: !1, line: 18, type: !10)
!23 = !DILocation(line: 18, column: 22, scope: !19)
!24 = !DILocation(line: 19, column: 11, scope: !19)
!25 = !DILocation(line: 19, column: 13, scope: !19)
!26 = !DILocation(line: 19, column: 12, scope: !19)
!27 = !DILocation(line: 19, column: 4, scope: !19)
!28 = distinct !DISubprogram(name: "foo", scope: !1, file: !1, line: 22, type: !29, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!29 = !DISubroutineType(types: !30)
!30 = !{!31, !10, !10, !36, !36}
!31 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !32, size: 64)
!32 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "fptr", file: !1, line: 2, size: 64, elements: !33)
!33 = !{!34}
!34 = !DIDerivedType(tag: DW_TAG_member, name: "p_fptr", scope: !32, file: !1, line: 4, baseType: !35, size: 64)
!35 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !8, size: 64)
!36 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !37, size: 64)
!37 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "wfsptr", file: !1, line: 10, size: 64, elements: !38)
!38 = !{!39}
!39 = !DIDerivedType(tag: DW_TAG_member, name: "wfptr", scope: !37, file: !1, line: 12, baseType: !40, size: 64)
!40 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !41, size: 64)
!41 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "fsptr", file: !1, line: 6, size: 64, elements: !42)
!42 = !{!43}
!43 = !DIDerivedType(tag: DW_TAG_member, name: "sptr", scope: !41, file: !1, line: 8, baseType: !31, size: 64)
!44 = !DILocalVariable(name: "a", arg: 1, scope: !28, file: !1, line: 22, type: !10)
!45 = !DILocation(line: 22, column: 23, scope: !28)
!46 = !DILocalVariable(name: "b", arg: 2, scope: !28, file: !1, line: 22, type: !10)
!47 = !DILocation(line: 22, column: 30, scope: !28)
!48 = !DILocalVariable(name: "a_fptr", arg: 3, scope: !28, file: !1, line: 22, type: !36)
!49 = !DILocation(line: 22, column: 49, scope: !28)
!50 = !DILocalVariable(name: "b_fptr", arg: 4, scope: !28, file: !1, line: 22, type: !36)
!51 = !DILocation(line: 22, column: 73, scope: !28)
!52 = !DILocation(line: 23, column: 7, scope: !53)
!53 = distinct !DILexicalBlock(scope: !28, file: !1, line: 23, column: 7)
!54 = !DILocation(line: 23, column: 8, scope: !53)
!55 = !DILocation(line: 23, column: 11, scope: !53)
!56 = !DILocation(line: 23, column: 14, scope: !53)
!57 = !DILocation(line: 23, column: 15, scope: !53)
!58 = !DILocation(line: 23, column: 7, scope: !28)
!59 = !DILocalVariable(name: "temp", scope: !60, file: !1, line: 25, type: !40)
!60 = distinct !DILexicalBlock(scope: !53, file: !1, line: 24, column: 4)
!61 = !DILocation(line: 25, column: 20, scope: !60)
!62 = !DILocation(line: 25, column: 25, scope: !60)
!63 = !DILocation(line: 25, column: 33, scope: !60)
!64 = !DILocation(line: 26, column: 27, scope: !60)
!65 = !DILocation(line: 26, column: 35, scope: !60)
!66 = !DILocation(line: 26, column: 42, scope: !60)
!67 = !DILocation(line: 26, column: 5, scope: !60)
!68 = !DILocation(line: 26, column: 13, scope: !60)
!69 = !DILocation(line: 26, column: 20, scope: !60)
!70 = !DILocation(line: 26, column: 25, scope: !60)
!71 = !DILocation(line: 27, column: 26, scope: !60)
!72 = !DILocation(line: 27, column: 32, scope: !60)
!73 = !DILocation(line: 27, column: 5, scope: !60)
!74 = !DILocation(line: 27, column: 13, scope: !60)
!75 = !DILocation(line: 27, column: 20, scope: !60)
!76 = !DILocation(line: 27, column: 25, scope: !60)
!77 = !DILocation(line: 28, column: 12, scope: !60)
!78 = !DILocation(line: 28, column: 20, scope: !60)
!79 = !DILocation(line: 28, column: 27, scope: !60)
!80 = !DILocation(line: 28, column: 5, scope: !60)
!81 = !DILocation(line: 30, column: 11, scope: !28)
!82 = !DILocation(line: 30, column: 19, scope: !28)
!83 = !DILocation(line: 30, column: 26, scope: !28)
!84 = !DILocation(line: 30, column: 4, scope: !28)
!85 = !DILocation(line: 31, column: 1, scope: !28)
!86 = distinct !DISubprogram(name: "clever", scope: !1, file: !1, line: 33, type: !87, scopeLine: 33, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!87 = !DISubroutineType(types: !88)
!88 = !{!31, !10, !10, !40, !40}
!89 = !DILocalVariable(name: "a", arg: 1, scope: !86, file: !1, line: 33, type: !10)
!90 = !DILocation(line: 33, column: 26, scope: !86)
!91 = !DILocalVariable(name: "b", arg: 2, scope: !86, file: !1, line: 33, type: !10)
!92 = !DILocation(line: 33, column: 33, scope: !86)
!93 = !DILocalVariable(name: "a_fptr", arg: 3, scope: !86, file: !1, line: 33, type: !40)
!94 = !DILocation(line: 33, column: 51, scope: !86)
!95 = !DILocalVariable(name: "b_fptr", arg: 4, scope: !86, file: !1, line: 33, type: !40)
!96 = !DILocation(line: 33, column: 74, scope: !86)
!97 = !DILocalVariable(name: "t1_fptr", scope: !86, file: !1, line: 34, type: !37)
!98 = !DILocation(line: 34, column: 18, scope: !86)
!99 = !DILocation(line: 35, column: 18, scope: !86)
!100 = !DILocation(line: 35, column: 12, scope: !86)
!101 = !DILocation(line: 35, column: 17, scope: !86)
!102 = !DILocalVariable(name: "t2_fptr", scope: !86, file: !1, line: 36, type: !37)
!103 = !DILocation(line: 36, column: 18, scope: !86)
!104 = !DILocation(line: 37, column: 18, scope: !86)
!105 = !DILocation(line: 37, column: 12, scope: !86)
!106 = !DILocation(line: 37, column: 17, scope: !86)
!107 = !DILocation(line: 38, column: 15, scope: !86)
!108 = !DILocation(line: 38, column: 17, scope: !86)
!109 = !DILocation(line: 38, column: 11, scope: !86)
!110 = !DILocation(line: 38, column: 4, scope: !86)
!111 = distinct !DISubprogram(name: "moo", scope: !1, file: !1, line: 42, type: !112, scopeLine: 42, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!112 = !DISubroutineType(types: !113)
!113 = !{!10, !114, !10, !10}
!114 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!115 = !DILocalVariable(name: "x", arg: 1, scope: !111, file: !1, line: 42, type: !114)
!116 = !DILocation(line: 42, column: 14, scope: !111)
!117 = !DILocalVariable(name: "op1", arg: 2, scope: !111, file: !1, line: 42, type: !10)
!118 = !DILocation(line: 42, column: 21, scope: !111)
!119 = !DILocalVariable(name: "op2", arg: 3, scope: !111, file: !1, line: 42, type: !10)
!120 = !DILocation(line: 42, column: 30, scope: !111)
!121 = !DILocalVariable(name: "a_fptr", scope: !111, file: !1, line: 43, type: !32)
!122 = !DILocation(line: 43, column: 17, scope: !111)
!123 = !DILocation(line: 44, column: 12, scope: !111)
!124 = !DILocation(line: 44, column: 18, scope: !111)
!125 = !DILocalVariable(name: "s_fptr", scope: !111, file: !1, line: 45, type: !32)
!126 = !DILocation(line: 45, column: 17, scope: !111)
!127 = !DILocation(line: 46, column: 12, scope: !111)
!128 = !DILocation(line: 46, column: 18, scope: !111)
!129 = !DILocalVariable(name: "m_fptr", scope: !111, file: !1, line: 48, type: !41)
!130 = !DILocation(line: 48, column: 18, scope: !111)
!131 = !DILocation(line: 49, column: 12, scope: !111)
!132 = !DILocation(line: 49, column: 16, scope: !111)
!133 = !DILocalVariable(name: "n_fptr", scope: !111, file: !1, line: 50, type: !41)
!134 = !DILocation(line: 50, column: 18, scope: !111)
!135 = !DILocation(line: 51, column: 12, scope: !111)
!136 = !DILocation(line: 51, column: 16, scope: !111)
!137 = !DILocalVariable(name: "goo_ptr", scope: !111, file: !1, line: 53, type: !138)
!138 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !87, size: 64)
!139 = !DILocation(line: 53, column: 20, scope: !111)
!140 = !DILocalVariable(name: "t_fptr", scope: !111, file: !1, line: 54, type: !31)
!141 = !DILocation(line: 54, column: 18, scope: !111)
!142 = !DILocation(line: 56, column: 21, scope: !111)
!143 = !DILocation(line: 56, column: 26, scope: !111)
!144 = !DILocation(line: 56, column: 14, scope: !111)
!145 = !DILocation(line: 56, column: 12, scope: !111)
!146 = !DILocation(line: 57, column: 5, scope: !111)
!147 = !DILocation(line: 57, column: 13, scope: !111)
!148 = !DILocation(line: 57, column: 20, scope: !111)
!149 = !DILocation(line: 57, column: 25, scope: !111)
!150 = !DILocation(line: 58, column: 12, scope: !111)
!151 = !DILocation(line: 58, column: 18, scope: !111)
!152 = !DILocation(line: 58, column: 25, scope: !111)
!153 = !DILocation(line: 58, column: 29, scope: !111)
!154 = !DILocation(line: 58, column: 5, scope: !111)
!155 = !DILocation(line: 60, column: 5, scope: !111)
