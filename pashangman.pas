program HangmanGame;

uses
  crt;

const
  MaxTries = 6;
  Words: array[1..10] of string = ('SUOMI', 'HELSINKI', 'PERKELE', 'METSA', 'RAKKAUS', 'HAUSKA', 'SAUNA', 'OLUT', 'TISSIT', 'VAPAUS');

var
  SelectedWord, HiddenWord: string;
  GuessedLetter: char;
  WrongGuesses: integer;
  i, RandomIndex: integer;
  LetterFound: boolean;

procedure InitializeGame;
begin
  Randomize;
  RandomIndex := Random(10) + 1;
  SelectedWord := Words[RandomIndex];
  HiddenWord := '';

  for i := 1 to Length(SelectedWord) do
    HiddenWord := HiddenWord + '_';

  WrongGuesses := 0;
end;

procedure DisplayGame;
begin
  clrscr;
  writeln('HANGMAN-PELI');
  writeln('-------------');
  writeln('Sana: ', HiddenWord);
  writeln('Vaarat arvaukset: ', WrongGuesses, '/', MaxTries);
end;

procedure ProcessGuess;
begin
  LetterFound := False;
  writeln;
  writeln('Kirjoita kirjain: ');
  readln(GuessedLetter);
  GuessedLetter := UpCase(GuessedLetter);

  for i := 1 to Length(SelectedWord) do
  begin
    if SelectedWord[i] = GuessedLetter then
    begin
      HiddenWord[i] := GuessedLetter;
      LetterFound := True;
    end;
  end;

  if not LetterFound then
    Inc(WrongGuesses);
end;

begin
  InitializeGame;

  while (WrongGuesses < MaxTries) and (HiddenWord <> SelectedWord) do
  begin
    DisplayGame;
    ProcessGuess;
  end;

  DisplayGame;

  if HiddenWord = SelectedWord then
    writeln('Onnittelut! Sina voitit!: ', SelectedWord)
  else
    writeln('Anteeksi, havisit. Sana oli: ', SelectedWord);

  writeln('Poistu milla tahansa nappaimella...');
  readkey;
end.
