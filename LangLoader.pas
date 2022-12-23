unit LangLoader;

interface

 uses SysUtils, Forms, Classes, StdCtrls, ExtCtrls, Buttons, Menus, ComCtrls,
      Dialogs, GeoFiles, URegions;

 procedure LoadLang(Lng: integer; Analyse:Boolean);
 procedure SaveLngs;

 var Inf  :array [0..511] of String;
     Lang :String = 'Russian';
     OldLang :String = 'Russian';
     Langs :array [0..1] of String = ('English','Russian');
implementation

procedure SaveLngs;
var I, J, k: integer;
    S: TStringList;
begin
  S := TStringList.Create;

  for i := 0 to Application.ComponentCount - 1 do
  begin
    S.Add(Application.Components[I].Name);


    if Application.Components[I] is TForm then
    Begin
       S.Add(Tform(Application.Components[I]).Caption);
       S.Add('');
       with Application.Components[I] as TForm Do
       Begin
         for J := 0 to ComponentCount - 1 do
         Begin
            S.Add(Components[J].Name);

            if Components[J] is TLabel then
               S.Add(TLabel(Components[J]).Caption);

            if Components[J] is TButton then
               S.Add(TButton(Components[J]).Caption);

            if Components[J] is TBitBtn then
               S.Add(TBitBtn(Components[J]).Caption);

            if Components[J] is TGroupBox then
               S.Add(TGroupBox(Components[J]).Caption);

            if Components[J] is TCheckBox then
               S.Add(TCheckBox(Components[J]).Caption);

            if Components[J] is TRadioButton then
               S.Add(TRadioButton(Components[J]).Caption);

            if Components[J] is TRadioGroup then
            Begin
               S.Add(TRadioGroup(Components[J]).Caption);
               for K := 0 to TRadioGroup(Components[J]).items.Count - 1 do
                 S.Add(TRadioGroup(Components[J]).items[K]);
            End;

            if Components[J] is TEdit then
               S.Add(TEdit(Components[J]).Text);

            if Components[J] is TMenuItem then
               S.Add(TMenuItem(Components[J]).Caption);

            if Components[J] is TSpeedButton then
            Begin
              S.Add(TSpeedButton(Components[J]).Caption);
              S.Add(TSpeedButton(Components[J]).Hint);
            End;

            if Components[J] is TPageControl then
            Begin
               for K := 0 to TPageControl(Components[J]).PageCount - 1 do
                 S.Add(TPageControl(Components[J]).Pages[K].Caption);
            End;
            S.Add('');
         End;
       End;
    End;

    S.Add('//');
  end;
  S.SaveToFile('Data\Editor\Default.txt');
  S.Free;

end;


procedure LoadLang(Lng: integer; Analyse:Boolean);
var S { S2, S3} : TStringList;
    I, J, K, L :Integer;
begin
   S  := TStringList.Create;
//   S2 := TStringList.Create;
//   S3 := TStringList.Create;

   OldLang := Lang;

   if Lng = -1 then
   Begin
     Lang := Langs[0];

     try
       if fileexists('..\Data\Language.config') then
        S.LoadFromFile('..\Data\Language.config')
        else
          S.LoadFromFile('Data\Language.config');
       Lang := Langs[StrToInt(S[0])];
     except
       Lang := Langs[1];
     end;
   End
    Else
     Lang := Langs[Lng];

  S.LoadFromFile('Data\Editor\'+Lang+'\Main.txt');

  K:=0;

  while K < S.Count-2 do
  Begin
    if S[K] <> '//' then
    inc(K);

    if S[K] = '//' then
    try
      inc(K);
      while s[K]='' do
        inc(K);

      for I := 0 to Application.ComponentCount - 1  do
         if Application.Components[I].Name = S[K] then
            with Application.Components[I] as TForm Do
            Begin

               {if Analyse then
               begin
                 for L := 0 to S2.Count - 1 do
                   S3.Add(S2[L]);
                 S2.Clear;
                 if S3.Count > 0 then
                 begin
                   S3.Add('----------'); S3.Add('');
                 end;
                 S3.Add(Application.Components[I].Name);
                 S3.Add('');
                 for J := 0 to ComponentCount - 1 do
                   S2.Add(Components[J].Name);
               end;    }

               inc(K);
               Caption := S[K];
               inc(K);
            while (S[K] <> '//')or(K < S.Count-1) do
            BEGIN
        //     if K >= 2300 then
         //              showmessage('xc');

               if (s[k]='//') or (s[K+1]='//') then
                  break;

               inc(K);

               while s[K]='' do
                inc(K);

               for J := 0 to ComponentCount - 1 do
               Begin
                 if S[K] = '' then
                   break;
                 if Components[J].Name = S[K] then
                 Begin
                    inc(K);

                    {if Analyse then
                      for L := 0 to S2.Count - 1 do
                        if S2[L] = Components[J].Name then
                        begin
                           S2.Delete(L);
                           break;
                        end;    }

                    if Components[J] is TLabel then
                      TLabel(Components[J]).Caption := S[K];

                    if Components[J] is TEdit then
                      TLabel(Components[J]).Caption := S[K];

                    if Components[J] is TBitBtn then
                    Begin
                      TBitBtn(Components[J]).Caption := S[K];
                      inc(k);
                      TBitBtn(Components[J]).Hint := S[K];
                    End;

                    if Components[J] is TSpeedButton then
                    Begin
                      TSpeedButton(Components[J]).Caption := S[K];
                      inc(k);
                      TSpeedButton(Components[J]).Hint := S[K];
                    End;

                    if Components[J] is TButton then
                      TButton(Components[J]).Caption := S[K];

                    if Components[J] is TGroupBox then
                      TGroupBox(Components[J]).Caption := S[K];

                    if Components[J] is TCheckBox then
                      TCheckBox(Components[J]).Caption := S[K];

                    if Components[J] is TRadioButton then
                      TRadioButton(Components[J]).Caption := S[K];

                    if Components[J] is TMenuItem then
                       TMenuItem(Components[J]).Caption  := S[K];

                    if Components[J] is TRadioGroup then
                    Begin
                      TRadioGroup(Components[J]).Caption := S[K];
                      inc(k);
                      L:=0;
                      while S[k]<>'' do
                      begin
                        if S[k]<>'' then
                           TRadioGroup(Components[J]).Items[L] := S[K];
                        inc(K);
                        inc(L);
                      end
                    End;

                    if Components[J] is TPageControl then
                    Begin
                      L:=0;
                      while S[k]<>'' do
                      begin
                        if S[k]<>'' then
                          TPageControl(Components[J]).Pages[L].Caption := S[K];
                        inc(K);
                        inc(L);
                      end
                    End;

                    if Components[J] is TComboBox then
                    Begin
                      L:=0;
                      while S[k]<>'' do
                      begin
                        if S[k]<>'' then
                          TCombobox(Components[J]).Items[L]:= S[K];
                        inc(K);
                        inc(L);
                      end
                    End;

                    if s[K+1]='//' then
                       break;

                    if s[K+1]='' then
                    inc(K);

                 End;

               End;
               End;

            End;


         Except
         //  S.Add(inttostr(k));
           ShowMessage('LANGUAGE LOADING ERROR IN STRING: ' + inttostr(k))
         End;

    End;


  S.LoadFromFile('Data\Editor\'+Lang+'\Info.txt');
  for I := 0 to length(Inf)-1 do
  Begin
    if I <= S.Count-1 then

    Inf[i]:= S[i]
      else
        Inf[i] := 'Error ['+IntToStr(I)+']';
  End;

  S.LoadFromFile('Data\Editor\'+Lang+'\RegNames.txt');
  for I := 0 to S.Count - 1 do
  begin
    RegionsNames[I] := s[I];

    if i>= 63 then
       break;
  end;

  S.LoadFromFile('Data\Editor\'+Lang+'\Locs.txt');

  if OldLang<>Lang then
    GeoTranslate(OldLang, Lang, 'Data\Editor\');

//  if Analyse then
//    S3.SaveToFile('Data\Editor\TestResult.txt');

  S.Free;
//  S2.Free;
//  S3.Free;
end;

end.
