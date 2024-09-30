program Snake;

uses crt;

const
  Width = 20;
  Height = 10;
  SnakeChar = '#';
  FoodChar = '*';
  EmptyChar = ' ';
  InitialLength = 3;

type
  TPosition = record
    x, y: integer;
  end;

  TSnake = array[1..100] of TPosition;

var
  Snake: TSnake;
  SnakeLength: integer;
  Food: TPosition;
  Direction: char;
  Key: char;
  GameOver: boolean;

procedure InitializeGame;
var
  i: integer;
begin
  SnakeLength := InitialLength;

  for i := 1 to SnakeLength do
  begin
    Snake[i].x := Width div 2 - i + 1;
    Snake[i].y := Height div 2;
  end;

  Randomize;
  Food.x := Random(Width) + 1;
  Food.y := Random(Height) + 1;

  Direction := 'r';
  GameOver := False;
end;

procedure DrawGame;
var
  i, j: integer;
  isSnakeCell: boolean;
  k: integer;
begin
  clrscr;

  for i := 1 to Height do
  begin
    for j := 1 to Width do
    begin
      isSnakeCell := False;

      for k := 1 to SnakeLength do
        if (Snake[k].x = j) and (Snake[k].y = i) then
          isSnakeCell := True;

      if isSnakeCell then
        write(SnakeChar)
      else if (Food.x = j) and (Food.y = i) then
        write(FoodChar)
      else
        write(EmptyChar);
    end;
    writeln;
  end;
end;

procedure HandleInput;
begin
  if KeyPressed then
  begin
    Key := ReadKey;
    case Key of
      'w': if Direction <> 'd' then Direction := 'u'; { Move up }
      's': if Direction <> 'u' then Direction := 'd'; { Move down }
      'a': if Direction <> 'r' then Direction := 'l'; { Move left }
      'd': if Direction <> 'l' then Direction := 'r'; { Move right }
    end;
  end;
end;

procedure UpdateSnake;
var
  i: integer;
  NewHead: TPosition;
begin
  for i := SnakeLength downto 2 do
  begin
    Snake[i] := Snake[i - 1];
  end;

  NewHead := Snake[1];
  case Direction of
    'u': NewHead.y := NewHead.y - 1;
    'd': NewHead.y := NewHead.y + 1;
    'l': NewHead.x := NewHead.x - 1;
    'r': NewHead.x := NewHead.x + 1;
  end;

  Snake[1] := NewHead;
end;

procedure CheckCollisions;
var
  i: integer;
begin
  if (Snake[1].x < 1) or (Snake[1].x > Width) or (Snake[1].y < 1) or (Snake[1].y > Height) then
    GameOver := True;

  for i := 2 to SnakeLength do
    if (Snake[1].x = Snake[i].x) and (Snake[1].y = Snake[i].y) then
      GameOver := True;

  if (Snake[1].x = Food.x) and (Snake[1].y = Food.y) then
  begin
    SnakeLength := SnakeLength + 1;

    Food.x := Random(Width) + 1;
    Food.y := Random(Height) + 1;
  end;
end;

{ Main game loop }
begin
  InitializeGame;

  while not GameOver do
  begin
    DrawGame;
    HandleInput;
    UpdateSnake;
    CheckCollisions;
    Delay(200);
  end;

  writeln('Game Over!');
end.