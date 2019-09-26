program Model_1;

uses crt;
uses  GRAPHABC;
var
  p, q1, q, torq: array[1..4] of real;
  r: array[1..5] of real;
  c, link: array[1..6] of integer;
  koord: array[1..540] of integer;
  i, j, y1, y2, clr, y, y3, diam, walk, value, fr, moment, corner, counter, counter1, pow: integer;
  a, a2, dr, kp, power, power1: real;
  zn: string;
  flw, fld, opt: boolean;


procedure ignit(i: integer);
var
  time, front, value: real;
begin
  time := 60 / (fr * 360);
  front := 25000 * time;
  value := front * pi * diam * diam / 4;
  if value > q1[i] / p[i] then
    value := q1[i] / p[i];
  q1[i] -= value * p[i];
  q[i] += 2 * value * p[i];
end;

procedure pressure(a1: real; i: integer);

begin
  
  if a1 >= 3.5 * pi then a1 -= 4 * pi;
  if a1 < (pi / 2) then begin
    q[i] := (((kp - 1) / 2 + (1 / 3)) + sin(a1) * (kp - 1) / 2 ) * dr;
    q1[i] := q[i];
    p[i] := dr;
    torq[i] := -((p[i] - 1) * pi * diam * diam * (sin(3 * pi / 2 - a1 - arcsin(((walk mod 2) / (walk*1.1)) * sin(a1))))) / 4000;
  end
  else if a1 < 1.5 * pi then begin
    p[i] := (q[i] + 1 / 3 * q[i] * ((a1 - pi / 2) / pi)) / (6 + sin(a1) * 5);
    if a1 >= (1.5 * pi - (corner * pi) / 180) then
      ignit(i);
    //if a1 > (1.5 * pi - 0.35) then
    //  q[i] += dr * (10 + 1 / 3) / 6;
    torq[i] := -((p[i] - 1) * pi * diam * diam * (sin(3 * pi / 2 - a1 - arcsin(((walk mod 2) / (walk + 20)) * sin(a1))))) / 4000;
  end
  else if a1 < 2.5 * pi then begin
    p[i] := (q[i] + 1 / 3 * q[i] * ((1.5 * pi - a1) / pi)) / (6 + sin(a1) * 5);
    if a1 >= (1.5 * pi - (corner * pi) / 180) then
      ignit(i);
    //if a1 < (1.5 * pi + 0.35) then
    //  q[i] += dr * (10 + 1 / 3) / 6;
    torq[i] := -((p[i] - 1) * pi * diam * diam * (sin(3 * pi / 2 - a1 - arcsin(((walk mod 2) / (walk + 20)) * sin(a1))))) / 4000;
  end
  else begin
    q[i] := (5 + sin(a1) * 5 ) * dr * 3 + 1;
    p[i] := q[i] / (6 + sin(a1) * 5);
    torq[i] := -((p[i] - 1) * pi * diam * diam * (sin(3 * pi / 2 - a1 - arcsin(((walk mod 2) / (walk + 20)) * sin(a1))))) / 4000;
  end;
  
end;

procedure Vvod(Key: integer);
begin
  if flw or fld then begin
    case key of
      //------------------------------------
      48..57: // Условие нажатия на символьные клавиши
      zn := zn + Chr(key);
    end;
    // ----------------------------------
    if key = 8 then zn := Copy(zn, 1, zn.Length - 1);
    // Условия нажатия на Delete и т.п. - можно прописать
    if key = 46 then zn := '';
    if key = 13 then begin
      if flw then TryStrToInt(zn, walk);
      flw := false;
      if fld then TryStrToInt(zn, diam); 
      fld := false;
      value := round((pi * diam * diam * walk) / 1000);
    end;
  end;
end;

procedure MouseDown(x, y, mb: integer);
begin
  if (y > 600) and (y < 650) then//ДАД
  begin
    if (x > 600) and (x < 650) then
      dr -= 0.1
    else if (x > 700) and (x < 750) then
      dr += 0.1;
  end;
  
  if (x > 760) and (x < 790) then
  begin
    if(y > 250) and (y < 280) then
      kp -= 0.1
    else if(y > 370) and (y < 400) then
      fr -= 500
  end
  else if (x > 840) and (x < 870) then
  begin
    if(y > 250) and (y < 280) then
      kp += 0.1
    else if(y > 370) and (y < 400) then
      fr += 500
  end
  else if(x > 790) and (x < 840) then
    if(y > 75) and (y < 90) then
    begin
      flw := true;
      fld := false;
      zn := '' + walk;
    end
    else if(y > 135) and (y < 150) then
    begin
      fld := true;
      flw := false;
      zn := '' + diam;
    end;
  if(x > 900) and (x < 930) and (y > 250) and (y < 280) and (not opt) then begin
    opt := true;
    c[1] := 90;
    c[2] := -90;
    c[3] := 0;
    c[4] := 45;
    c[5] := -45;
    link[1] := 1;
    link[2] := 2;
    link[3] := 3;
    link[4] := 4;
    link[5] := 5;
    link[6] := 0;
  end;
end;

begin
  counter := -1;
  counter1 := 1;
  i := 0;
  diam := 100;
  walk := 200;
  value := round((pi * diam * diam * walk) / 1000);
  fr := 1000;
  OnMouseDown := MouseDown;
  OnKeyDown := Vvod;
  LockDrawing;
  setwindowsize(1280, 1024);
  Line(99, 95, 99, 305);
  Line(200, 95, 200, 305);
  Line(249, 95, 249, 305);
  Line(350, 95, 350, 305);
  Line(399, 95, 399, 305);
  Line(500, 95, 500, 305);
  Line(549, 95, 549, 305);
  Line(650, 95, 650, 305);
  
  a := 0;
  dr := 2;
  kp := 10;
  while(true) do 
  begin
    Window.Clear;
    //очистка объектов
    Line(99, 95, 99, 305);
    Line(200, 95, 200, 305);
    Line(249, 95, 249, 305);
    Line(350, 95, 350, 305);
    Line(399, 95, 399, 305);
    Line(500, 95, 500, 305);
    Line(549, 95, 549, 305);
    Line(650, 95, 650, 305);
    a += 0.03141592653;
    if a >= 1.75 * pi then
      a -= 2 * pi;
    a2 := 2 * a;
    //шатуны
    y1 := 200 + Round(sin(a2) * 100);
    y2 := 200 - Round(sin(a2) * 100);
    clr := 64 + Round(sin(a2) * 32);
    y := y1 + 208 + round(sin(2 * a2 + pi) * 12);
    Brush.Color := RGB(clr, clr, clr);
    FillRect(130, y1 + 25, 170, y);
    FillRect(580, y1 + 25, 620, y);
    //основание шатуна 1,4 цилиндра
    Brush.Color := RGB(255, 171, 0);
    FillRect(110, y, 190, y + 40);
    FillRect(560, y, 640, y + 40);
    FillRect(180, y + 20, 190, 442);
    FillRect(110, y + 20, 120, 442);
    FillRect(560, y + 20, 570, 442);
    FillRect(630, y + 20, 640, 442);
    
    //показ креплений 1,4 цилиндра
    Brush.Color := RGB(clr, clr, clr);
    FillRect(130, y, 170, y + round(cos(a2) * 20));
    FillRect(580, y, 620, y + round(cos(a2) * 20));
    clr := 64 - Round(cos(a2) * 32);
    y3 := y2 + 208 - round(sin(2 * a2) * 12);
    Brush.Color := RGB(clr, clr, clr);
    FillRect(280, y2 + 25, 320, y3);
    FillRect(430, y2 + 25, 470, y3);
    //поршни
    Brush.Color := clGreen;
    FillRect(100, y1, 200, y1 + 50);
    FillRect(250, y2, 350, y2 + 50);
    FillRect(400, y2, 500, y2 + 50);
    FillRect(550, y1, 650, y1 + 50);
    //основание шатуна 2,3 цилиндра
    Brush.Color := RGB(255, 171, 0);
    //FillRect(120,y,180,y+40);
    //FillRect(570,y,630,y+40);
    FillRect(260, y3, 340, y3 + 40);
    FillRect(410, y3, 490, y3 + 40);
    FillRect(260, y3 + 20, 270, 442);
    FillRect(330, y3 + 20, 340, 442);
    FillRect(410, y3 + 20, 420, 442);
    FillRect(480, y3 + 20, 490, 442);
    //показ креплений 2,3 цилиндра
    Brush.Color := RGB(clr, clr, clr);
    FillRect(280, y3, 320, y3 - round(sin(a2 + pi / 2) * 20));
    FillRect(430, y3, 470, y3 - round(sin(a2 + pi / 2) * 20));
    //Основание коленвала
    Brush.Color := RGB(254, 170, 0);
    FillRect(120, 427, 60, 457);
    FillRect(180, 427, 270, 457);
    FillRect(330, 427, 420, 457);
    FillRect(480, 427, 570, 457);
    FillRect(630, 427, 700, 457);
    arc(150, 100, 51, 0, 180);
    arc(300, 100, 51, 0, 180);
    arc(450, 100, 51, 0, 180);
    arc(600, 100, 51, 0, 180);
    pressure(a2, 1);
    Floodfill(150, 75, rgb(255, 255 - round((p[1] / 50) * 255), 255 - round((p[1] / 50) * 255)));
    pressure(a2 + 3 * pi, 3);
    Floodfill(450, 75, rgb(255, 255 - round((p[3] / 50) * 255), 255 - round((p[3] / 50) * 255)));
    pressure(a2 + 2 * pi, 4);
    Floodfill(600, 75, rgb(255, 255 - round((p[4] / 50) * 255), 255 - round((p[4] / 50) * 255)));
    pressure(a2 + pi, 2);
    Floodfill(300, 75, rgb(255, 255 - round((p[2] / 50) * 255), 255 - round((p[2] / 50) * 255)));
    
    // кнопки
    
    FillRect(900, 250, 930, 280);
    FillRect(760, 250, 790, 280);//СЖ
    TextOut(772, 256, '-');//
    FillRect(840, 250, 870, 280);//
    TextOut(851, 257, '+');//
    FillRect(760, 370, 790, 400);//Обороты
    TextOut(772, 376, '-');//
    FillRect(840, 370, 870, 400);//
    TextOut(851, 377, '+');//
    FillRect(600, 600, 650, 650);//ДАД(ДМРВ)
    TextOut(625, 615, '-');//
    FillRect(700, 600, 750, 650);//
    TextOut(725, 615, '+');//
    TextOut(725, 615, moment);//
    FillRect(760, 490, 1300, 700);//
    pow := round(torq[1] + torq[2] + torq[3] + torq[4]);
    koord[1 + (i mod 540)] := pow;
    for j := 0 to 539 do 
    begin
      if ((620 - koord[1 + ((i + j) mod 540)]) < 760) then
        SetPixel(760 + j, 620 - koord[1 + ((i + j) mod 540)], clBlue)
      else SetPixel(760 + j, 620, clBlue);
      SetPixel(760 + j, 620, clBlack);
    end;
    i := (i + 1) mod 540;
    if(not flw) then begin
      Brush.Color := RGB(255, 255, 255);
      TextOut(790, 75, walk + ' мм')
    end
    else 
    begin
      SetBrushColor(clBlue);
      TextOut(790, 75, zn + ' мм');
    end;
    if(not fld) then 
    begin
      Brush.Color := RGB(255, 255, 255);
      TextOut(790, 135, diam + ' мм');
    end
    else 
    begin
      SetBrushColor(clBlue);
      TextOut(790, 135, zn + ' мм');
    end;
    Brush.Color := RGB(255, 255, 255);
    TextOut(760, 195, value + ' cм^3');
    TextOut(805, 255, kp); //вывод степени сжатия
    TextOut(805, 315, value * dr + ' см^2'); //вывод объемного расхода воздуха/оборот
    TextOut(805, 375, fr);//вывод оборотов
    TextOut(665, 615, dr);
    TextOut(760, 50, 'Длинна хода поршня:');
    TextOut(760, 110, 'Диаметр поршня:');
    TextOut(760, 170, 'Рабочий объем:');
    TextOut(760, 230, 'Степень сжатия:');
    TextOut(900, 230, 'Угол опережения зажигания(оптимизация):');
    TextOut(940, 256, corner);//
    TextOut(760, 290, 'Количество смеси:');
    TextOut(760, 350, 'Обороты:');
    TextOut(760, 410, 'Удельный расход топлива:');
    TextOut(760, 440, (value * dr * 0.1108) / (2*power1));
    TextOut(760, 470, 'График мощности/удельного расхода');
    if opt then begin
    Brush.Color := RGB(0, 255, 0);
    FillRect(900, 250, 930, 280);
      corner := c[link[counter1]];
      inc(counter);
      if (counter >= 200) and (counter <= 250) then
        if ((p[1] > 50) or (p[2] > 50) or (p[3] > 50) or (p[4] > 50)) then
          power -= abs(pow)
        else
          power += pow;
      if (counter > 250) then begin
        r[link[counter1]] := power;
        power1 := power;
        power := 0;
        counter := -1;
        inc(counter1);
      end;
      if (link[counter1] = 0) then begin
        power := 0;
        counter1 := 1;
        counter := -1;
        if (r[1] >= r[2]) and (r[1] >= r[3]) and (r[1] >= r[4]) and (r[1] >= r[5]) then begin
          c[2] := c[4];
          r[2] := c[4];
          link[1] := 3;
          link[2] := 4;
          link[3] := 5;
          link[4] := 0;
        end
        else if (r[2] >= r[1]) and (r[2] >= r[3]) and (r[2] >= r[4]) and (r[2] >= r[5]) then begin
          c[1] := c[5];
          r[1] := c[5];
          link[1] := 3;
          link[2] := 4;
          link[3] := 5;
          link[4] := 0;
        end
        else if (r[3] >= r[1]) and (r[3] >= r[2]) and (r[3] >= r[4]) and (r[3] >= r[5]) then begin
          c[1] := c[4];
          c[2] := c[5];
          r[1] := c[4];
          r[2] := c[5];
          link[1] := 4;
          link[2] := 5;
          link[3] := 0;
        end
        else if (r[4] >= r[1]) and (r[4] >= r[2]) and (r[4] >= r[3]) and (r[4] >= r[5]) then begin
          c[2] := c[3];
          r[2] := r[3];
          r[3] := r[4];
          link[1] := 4;
          link[2] := 5;
          link[3] := 0;
        end
        else if (r[5] > r[1]) and (r[5] > r[2]) and (r[5] > r[3]) and (r[5] > r[4]) then begin
          c[1] := c[3];
          r[1] := r[3];
          r[3] := r[5];
          link[1] := 4;
          link[2] := 5;
          link[3] := 0;
        end;
        if (abs(c[1] - c[2]) < 3) then begin
          corner := round((c[1] + c[2]) / 2);
          opt := false;
        end
        else begin
          c[3] := round((c[1] + c[2]) / 2);
          c[4] := round((c[1] + c[3]) / 2);
          c[5] := round((c[3] + c[2]) / 2);
        end;
      end;
    end;

    Redraw;
    
  end;
end.
