{
  Winter Camp 2003                      Xmas
  Improved Algorithm  Written  By  Zhou Yuan
       Compiled By Borland Delphi 7.0

  See more description in my report document
}

{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q+,R+,S+,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE CONSOLE}
{$R-,Q-,S-}
Uses
     xmas_p;

Const
    InFile     = 'xmas.dat';
    Limit      = 100000;
    LimitSteps = 50000000;
    LimitTestTime
               = 100;

Type
    Tdata      = array[1..Limit] of longint;
    Tpossible  = array[1..Limit] of boolean;
    Thistory   = array[1..LimitTestTime] of
                   record
                       map , deep            : longint;
                   end;

Var
    data ,
    index ,
    last       : Tdata;
    possible   : Tpossible;
    history    : Thistory;
    N , oknum  : longint;

procedure init;
var
    i          : longint;
begin
    randomize;
    StartGame;
    assign(INPUT , InFile); ReSet(INPUT);
      readln(N);
      for i := 1 to N do
        begin
            read(data[i]);
            index[data[i]] := i;
        end;
    Close(INPUT);
    fillchar(possible , sizeof(possible) , 1);
end;

function check(p1 , p2 , maxdeep : longint) : boolean;
var
    find , i   : longint;
begin
    find := 0;
    check := false;
    for i := 1 to N do
      begin
          if data[p1] - data[p2] > maxdeep then
            exit
          else
            if data[p1] - data[p2] = maxdeep then
              find := 1;
          inc(p1);
          if p1 > N then
            p1 := 1;
          inc(p2);
          if p2 > N then
            p2 := 1;
      end;
    if find = 1 then
      check := true;
end;

procedure work;
var
    tmp        : Tpossible;
    deep ,
    target , p ,
    number ,
    totaltime ,
    i , nowstep ,
    t , circle ,
    pp         : longint;
begin
    oknum := N;
    totaltime := 0;
    fillchar(last , sizeof(last) , 0);
    pp := 1;
    while true do
      begin
          number := random(oknum) + 1;
          p := 1;
          while number > 0 do
            begin
                if possible[p] then dec(number);
                inc(p);
            end;
          dec(p);

          rotate(p - 1);
          deep := Drop;
          rotate(N - p + 1);
          fillchar(tmp , sizeof(tmp) , 0);
          inc(totaltime);
          history[totaltime].map := p;
          history[totaltime].deep := deep;
          if possible[p] then
            begin
                possible[p] := false;
                dec(oknum);
            end;

          t := N - random(10);
          if t <= 0 then t := 0;
          for i := 1 to t - deep - 1 do
            begin
                target := index[i] - index[t] + p;
                if target > N then
                  dec(target , N);
                if target <= 0 then
                  inc(target , N);
                if possible[target] then
                  begin
                      possible[target] := false;
                      dec(oknum);
                  end;
            end;
          for i := 1 to N do
            if data[i] > deep then
              begin
                  target := index[data[i] - deep] - i + p;
                  if target > N then
                    dec(target , N);
                  if target <= 0 then
                    inc(target , N);
                  tmp[target] := true;
              end;
          oknum := 0;
          for i := 1 to N do
            if tmp[i] and possible[i] then
              inc(oknum)
            else
              possible[i] := false;

          nowstep := 0; circle := 0;
          while (nowstep <= LimitSteps) and (circle <= N) do
            begin
                if not possible[pp] or (last[pp] = totaltime) then
                  inc(circle)
                else
                  begin
                      circle := 0;
                      if not check(history[last[pp] + 1].map , pp , history[last[pp] + 1].deep) then
                        begin
                            dec(oknum);
                            possible[pp] := false;
                        end;
                      inc(last[pp]);
                      inc(nowstep , N);
                  end;

                if pp = N then
                  pp := 1
                else
                  inc(pp);
            end;
      end;
end;

Begin
    init;
    work;
End.
