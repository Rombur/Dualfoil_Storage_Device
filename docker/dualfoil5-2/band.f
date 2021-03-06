      SUBROUTINE BAND(J)
      IMPLICIT REAL*8(A-H,O-Z)
      DIMENSION E(6,7,402)
      COMMON A(6,6),B(6,6),C(6,402),D(6,13),G(6),X(6,6),Y(6,6),N,NJ
      SAVE E,NP1
  101 FORMAT (/15H DETERM=0 AT J=,I4)
      IF (J-2)  1,6,8
    1 NP1= N + 1
      DO 2 I=1,N
      D(I,2*N+1)= G(I)
      DO 2 L=1,N
      LPN= L + N
    2 D(I,LPN)= X(I,L)
      CALL MATINV (N,2*N+1,DETERM)
      IF (DETERM)  4,3,4
    3 PRINT 101, J
    4 DO 5 K=1,N
      E(K,NP1,1)= D(K,2*N+1)
      DO 5 L=1,N
      E(K,L,1)= - D(K,L)
      LPN= L + N
    5 X(K,L)= - D(K,LPN)
      RETURN
    6 DO 7 I=1,N
      DO 7 K=1,N
      DO 7 L=1,N
    7 D(I,K)= D(I,K) + A(I,L)*X(L,K)
    8 IF (J-NJ)  11,9,9
    9 DO 10 I=1,N
      DO 10 L=1,N
      G(I)= G(I) - Y(I,L)*E(L,NP1,J-2)
      DO 10 M=1,N
   10 A(I,L)= A(I,L) + Y(I,M)*E(M,L,J-2)
   11 DO 12 I=1,N
      D(I,NP1)= - G(I)
      DO 12 L=1,N
      D(I,NP1)= D(I,NP1) + A(I,L)*E(L,NP1,J-1)
      DO 12 K=1,N
   12 B(I,K)= B(I,K) + A(I,L)*E(L,K,J-1)
      CALL MATINV (N,NP1,DETERM)
      IF (DETERM)  14,13,14
   13 PRINT 101, J
   14 DO 15 K=1,N
      DO 15 M=1,NP1
   15 E(K,M,J)= - D(K,M)
      IF (J-NJ)  20,16,16
   16 DO 17 K=1,N
   17 C(K,J)= E(K,NP1,J)
      DO 18 JJ=2,NJ
      M= NJ - JJ + 1
      DO 18 K=1,N
      C(K,M)= E(K,NP1,M)
      DO 18 L=1,N
   18 C(K,M)= C(K,M) + E(K,L,M)*C(L,M+1)
      DO 19 L=1,N
      DO 19 K=1,N
   19 C(K,1)= C(K,1) + X(K,L)*C(L,3)
   20 RETURN
      END
      
      
      SUBROUTINE MATINV (N,M,DETERM)
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON A(6,6),B(6,6),C(6,402),D(6,13)
      DIMENSION ID(6)
      DETERM=1.0
      DO 1 I=1,N
    1 ID(I)=0
      DO 18 NN=1,N
      BMAX=1.1
      DO 6 I=1,N
      IF(ID(I).NE.0) GO TO 6
      BNEXT=0.0
      BTRY=0.0
      DO 5 J=1,N
      IF(ID(J).NE.0) GO TO 5
      IF(DABS(B(I,J)).LE.BNEXT) GO TO 5
      BNEXT=DABS(B(I,J))
      IF(BNEXT.LE.BTRY) GO TO 5
      BNEXT=BTRY
      BTRY=DABS(B(I,J))
      JC=J
    5 CONTINUE
      IF(BNEXT.GE.BMAX*BTRY) GO TO 6
      BMAX=BNEXT/BTRY
      IROW=I
      JCOL=JC
    6 CONTINUE
      IF(ID(JC).EQ.0) GO TO 8
      DETERM=0.0
      RETURN
    8 ID(JCOL)=1
      IF(JCOL.EQ.IROW) GO TO 12
      DO 10 J=1,N
      SAVE=B(IROW,J)
      B(IROW,J)=B(JCOL,J)
   10 B(JCOL,J)=SAVE
      DO 11 K=1,M
      SAVE=D(IROW,K)
      D(IROW,K)=D(JCOL,K)
   11 D(JCOL,K)=SAVE
   12 F=1.0/B(JCOL,JCOL)
      DO 13 J=1,N
   13 B(JCOL,J)=B(JCOL,J)*F
      DO 14 K=1,M
   14 D(JCOL,K)=D(JCOL,K)*F
      DO 18 I=1,N
      IF(I.EQ.JCOL) GO TO 18
      F=B(I,JCOL)
      DO 16 J=1,N
   16 B(I,J)=B(I,J)-F*B(JCOL,J)
      DO 17 K=1,M
   17 D(I,K)=D(I,K)-F*D(JCOL,K)
   18 CONTINUE
      RETURN
      END

