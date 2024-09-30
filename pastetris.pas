program Tetris;

uses crt;

const
  Rows = 20;
  Cols = 10;
  EmptyCell = '.';
  BlockCell = '#';

type
  TGrid = array[1..Rows, 1..Cols] of char;
  TTetrimino = array[1..4, 1..4] of char;

var
  Grid: TGrid;
  Key: char;
  x, y: integer;
  CurrentTetrimino: TTetrimino;
  BlockIndex: integer;

const
  Tetrimino_I: TTetrimino = (
    ('.', '#', '.', '.'),
    ('.', '#', '.', '.'),
    ('.', '#', '.', '.'),
    ('.', '#', '.', '.')
  );

  Tetrimino_O: TTetrimino = (
    ('#', '#', '.', '.'),
    ('#', '#', '.', '.'),
    ('.', '.', '.', '.'),
    ('.', '.', '.', '.')
  );

  Tetrimino_T: TTetrimino = (
    ('.', '#', '.', '.'),
    ('#', '#', '#', '.'),
    ('.', '.', '.', '.'),
    ('.', '.', '.', '.')
  );

  Tetrimino_L: TTetrimino = (
    ('#', '.', '.', '.'),
    ('#', '.', '.', '.'),
    ('#', '#', '.', '.'),
    ('.', '.', '.', '.')
  );

  Tetrimino_J: TTetrimino = (
    ('.', '.', '#', '.'),
    ('.', '.', '#', '.'),
    ('.', '#', '#', '.'),
    ('.', '.', '.', '.')
  );

  Tetrimino_S: TTetrimino = (
    ('.', '#', '#', '.'),
    ('#', '#', '.', '.'),
    ('.', '.', '.', '.'),
    ('.', '.', '.', '.')
  );

  Tetrimino_Z: TTetrimino = (
    ('#', '#', '.', '.'),
    ('.', '#', '#', '.'),
    ('.', '.', '.', '.'),
    ('.', '.', '.', '.')
  );

procedure InitializeGrid;
var
  i, j: integer;
begin
  for i := 1 to Rows do
    for j := 1 to Cols do
      Grid[i, j] := EmptyCell;
end;

procedure DisplayGrid;
var
  i, j: integer;
begin
  clrscr;
  for i := 1 to Rows do
  begin
    for j := 1 to Cols do
      write(Grid[i, j], ' ');
    writeln;
  end;
end;

procedure PlaceTetrimino(var Grid: TGrid; Tetrimino: TTetrimino; x, y: integer);
var
  i, j: integer;
begin
  for i := 1 to 4 do
    for j := 1 to 4 do
      if Tetrimino[i, j] = BlockCell then
        Grid[y + i - 1, x + j - 1] := Tetrimino[i, j];
end;

procedure RemoveTetrimino(var Grid: TGrid; Tetrimino: TTetrimino; x, y: integer);
var
  i, j: integer;
begin
  for i := 1 to 4 do
    for j := 1 to 4 do
      if Tetrimino[i, j] = BlockCell then
        Grid[y + i - 1, x + j - 1] := EmptyCell;
end;

procedure HandleKeyPress(var x, y: integer);
begin
  if KeyPressed then
  begin
    Key := ReadKey;
    case Key of
      'a': if x > 1 then x := x - 1; { Move left }
      'd': if x + 4 <= Cols then x := x + 1; { Move right }
      's': y := y + 1; { Move down faster }
    end;
  end;
end;

function CollisionCheck(Tetrimino: TTetrimino; x, y: integer): boolean;
var
  i, j: integer;
begin
  CollisionCheck := False;
  for i := 1 to 4 do
    for j := 1 to 4 do
      if (Tetrimino[i, j] = BlockCell) and ((y + i > Rows) or (Grid[y + i, x + j - 1] <> EmptyCell)) then
      begin
        CollisionCheck := True;
        exit;
      end;
end;

procedure ClearFullRows;
var
  i, j: integer;
  full: boolean;
begin
  for i := Rows downto 1 do
  begin
    full := True;
    for j := 1 to Cols do
      if Grid[i, j] = EmptyCell then
      begin
        full := False;
        break;
      end;
    if full then
    begin
      for j := i downto 2 do
        Grid[j] := Grid[j - 1];
      for j := 1 to Cols do
        Grid[1, j] := EmptyCell;
    end;
  end;
end;

function GetRandomTetrimino: TTetrimino;
begin
  case Random(7) of
    0: GetRandomTetrimino := Tetrimino_I;
    1: GetRandomTetrimino := Tetrimino_O;
    2: GetRandomTetrimino := Tetrimino_T;
    3: GetRandomTetrimino := Tetrimino_L;
    4: GetRandomTetrimino := Tetrimino_J;
    5: GetRandomTetrimino := Tetrimino_S;
    6: GetRandomTetrimino := Tetrimino_Z;
  end;
end;

begin
  Randomize;
  InitializeGrid;

  x := 4;
  y := 1;

  CurrentTetrimino := GetRandomTetrimino;

  repeat
    RemoveTetrimino(Grid, CurrentTetrimino, x, y);

    HandleKeyPress(x, y);

    if not CollisionCheck(CurrentTetrimino, x, y + 1) then
      y := y + 1
    else
    begin
      PlaceTetrimino(Grid, CurrentTetrimino, x, y);

      ClearFullRows;

      y := 1;
      x := 4;
      CurrentTetrimino := GetRandomTetrimino; { Get a new random Tetrimino }
    end;

    PlaceTetrimino(Grid, CurrentTetrimino, x, y);

    DisplayGrid;

    Delay(500);

  until Key = #27; { Exit on Escape key }

  writeln('Game Over!');
end.