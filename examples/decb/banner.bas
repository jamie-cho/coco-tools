100 CLEAR3000
110 DIM CH(258),CL(4),R$(6),S$(6)
120 CLS: PRINT@12,"BANNER"
130 PRINT@64,"COLOR (1-8)";: INPUT CO
140 IF (CO<1 OR CO>8) THEN PRINT@64," ": GOTO 130
150 CO=128+(CO-1)*16+15
160 INPUT "ENTER 1 TO 36 CHARACTERS";A$
170 IF LEN(A$)>36 THEN 160
180 CLS
190 A$="     "+A$
200 DATA 14,17,19,21,25,17,14
210 DATA 4,12,4,4,4,4,14
220 DATA 14,17,1,14,16,16,31
230 DATA 14,17,1,6,1,17,14
240 DATA 2,6,10,18,31,2,2
250 DATA 31,16,30,1,1,17,14
260 DATA 6,8,16,30,17,17,14
270 DATA 31,1,2,4,8,16,16
280 DATA 14,17,17,14,17,17,14
290 DATA 14,17,17,15,1,2,12
300 DATA 0,0,0,0,0,0,0
310 DATA 4,10,17,17,31,17,17
320 DATA 30,9,9,14,9,9,30
330 DATA 14,17,16,16,16,17,14
340 DATA 30,9,9,9,9,9,30
350 DATA 31,16,16,30,16,16,31
360 DATA 31,16,16,28,16,16,16
370 DATA 15,16,16,19,17,17,15
380 DATA 17,17,17,31,17,17,17
390 DATA 14,4,4,4,4,4,14
400 DATA 1,1,1,1,1,17,14
410 DATA 17,18,20,24,20,18,17
420 DATA 16,16,16,16,16,16,31
430 DATA 17,27,21,21,17,17,17
440 DATA 17,25,21,19,17,17,17
450 DATA 14,17,17,17,17,17,14
460 DATA 30,17,17,30,16,16,16
470 DATA 14,17,17,17,21,18,13
480 DATA 30, 17, 17,30,20, 18, 17
490 DATA 14,17,16,14,1,17,14
500 DATA 31,4,4,4,4,4,4
510 DATA 17,17,17,17,17,17,14
520 DATA 17,17,17,10,10,4,4
530 DATA 17,17,17,17,21,27,17
540 DATA 17,17,10,4,10,17,17
550 DATA 17,17,10,4,4,4,4
560 DATA 31,1,2,4,8,16,31
570 FOR I=0 TO 37*7-1
580 READ CH(I)
590 NEXT I
600 FOR I=0 TO 6
610 S$(I)=""
620 NEXT I
630 FOR J=1 TO LEN(A$)
640 B$=MID$(A$,J,1): IF B$=" " THEN I=10: GOTO 690
650 I=ASC(B$)-48: IF I<0 THEN I=10: GOTO 690
660 IF I<10 THEN 690
670 IF I<17 THEN I=10: GOTO 690
680 I=I-6
690 I=I*7
700 FOR R=0 TO 6
710 A=CH(I+R)
720 FOR C=0 TO 4
730 CL(4-C)=A-INT(A/2)*2: A=INT(A/2)
740 NEXT C
750 RW$=""
760 FOR K=0 TO 4
770 IF CL(K)=O THEN RW$=RW$+" "
780 IF CL(K)=1 THEN RW$=RW$+CHR$(CO)
790 NEXT K
800 RW$=RW$+" "
810 S$(R)=S$(R)+RW$
820 NEXT R
830 NEXT J
840 FOR K=1 TO LEN(A$)*6
850 FOR R=0 TO 6
860 R$(R)=MID$(S$(R),K,30)
870 NEXT R
880 PRINT@130,R$(0);
890 PRINT@162,R$(1);
900 PRINT@194,R$(2),
910 PRINT@226,R$(3);
920 PRINT@258,R$(4);
930 PRINT@290,R$(5);
940 PRINT@322,R$(6);
950 NEXT K
960 GOTO 840