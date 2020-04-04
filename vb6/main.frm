VERSION 5.00
Object = "{C1A8AF28-1257-101B-8FB0-0020AF039CA3}#1.1#0"; "mci32.ocx"
Begin VB.Form main 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "UberOrbs!"
   ClientHeight    =   6420
   ClientLeft      =   150
   ClientTop       =   450
   ClientWidth     =   8325
   Icon            =   "main.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   6420
   ScaleWidth      =   8325
   StartUpPosition =   2  'CenterScreen
   Begin MCI.MMControl MMControl1 
      Height          =   495
      Left            =   960
      TabIndex        =   4
      Top             =   120
      Visible         =   0   'False
      Width           =   3540
      _ExtentX        =   6244
      _ExtentY        =   873
      _Version        =   393216
      Enabled         =   0   'False
      DeviceType      =   ""
      FileName        =   ""
   End
   Begin VB.Timer tmr_newlevel 
      Left            =   360
      Top             =   0
   End
   Begin VB.TextBox Text1 
      Alignment       =   2  'Center
      Height          =   285
      Left            =   8520
      MaxLength       =   3
      TabIndex        =   2
      Text            =   "75"
      ToolTipText     =   "You determine the amount to attempt to vanquish..."
      Top             =   720
      Width           =   1215
   End
   Begin VB.Timer MoveOrbs 
      Left            =   0
      Top             =   0
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Start It"
      Height          =   495
      Left            =   8520
      TabIndex        =   1
      ToolTipText     =   "hmmm...i wonder what this does... >:)"
      Top             =   120
      Width           =   1215
   End
   Begin VB.PictureBox arena 
      AutoRedraw      =   -1  'True
      BackColor       =   &H80000007&
      DrawMode        =   15  'Merge Pen Not
      FillStyle       =   0  'Solid
      Height          =   6060
      Left            =   0
      ScaleHeight     =   400
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   550
      TabIndex        =   0
      Top             =   0
      Width           =   8310
   End
   Begin VB.Label Label1 
      Alignment       =   2  'Center
      BorderStyle     =   1  'Fixed Single
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   0
      TabIndex        =   3
      ToolTipText     =   "Displays the total that have been vanquished!"
      Top             =   6120
      Width           =   8295
   End
   Begin VB.Menu mnu_file 
      Caption         =   "File"
      Begin VB.Menu mnu_close 
         Caption         =   "Close"
      End
   End
   Begin VB.Menu mnu_startgame 
      Caption         =   "Start New Game!"
   End
   Begin VB.Menu mnu_level 
      Caption         =   "Level"
      Begin VB.Menu mnu_levelset 
         Caption         =   "1"
         Index           =   0
      End
      Begin VB.Menu mnu_levelset 
         Caption         =   "2"
         Index           =   1
      End
      Begin VB.Menu mnu_levelset 
         Caption         =   "3"
         Index           =   2
      End
      Begin VB.Menu mnu_levelset 
         Caption         =   "4"
         Index           =   3
      End
      Begin VB.Menu mnu_levelset 
         Caption         =   "5"
         Index           =   4
      End
      Begin VB.Menu mnu_levelset 
         Caption         =   "6"
         Index           =   5
      End
      Begin VB.Menu mnu_levelset 
         Caption         =   "7"
         Index           =   6
      End
      Begin VB.Menu mnu_levelset 
         Caption         =   "8"
         Index           =   7
      End
      Begin VB.Menu mnu_levelset 
         Caption         =   "9"
         Index           =   8
      End
      Begin VB.Menu mnu_levelset 
         Caption         =   "10"
         Index           =   9
      End
      Begin VB.Menu mnu_levelset 
         Caption         =   "11"
         Index           =   10
      End
      Begin VB.Menu mnu_levelset 
         Caption         =   "12"
         Index           =   11
      End
   End
   Begin VB.Menu mnu_options 
      Caption         =   "Options"
      Begin VB.Menu mnu_beep 
         Caption         =   "Sounds"
         Checked         =   -1  'True
      End
      Begin VB.Menu mnu_deflection 
         Caption         =   "Rubber Orbs"
      End
   End
   Begin VB.Menu mnu_help 
      Caption         =   "Help"
      Begin VB.Menu mnu_assist 
         Caption         =   "Teach me quick!"
      End
      Begin VB.Menu mnu_about 
         Caption         =   "About UberOrbs!"
      End
   End
End
Attribute VB_Name = "main"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
' tiny 8px, large 50px
' board 550px width, 400px height

Private Type Img_Orb
    XCoord As Long
    YCoord As Long
    angle As Long
    Speed As Double
    Radius As Long
    Color As Long
    State As Integer '0=dead, 1=mini, 2=growing, 3=big (uses life), 4=shrinking!
    Life As Long ' # is set, 40 = 2 seconds of life, 50ms tick interval
End Type

Private Type SqueakKaBoom
    DidClick As Boolean
    XCoord As Long
    YCoord As Long
    Radius As Long
    Life As Long
End Type

Dim TotalOrbs As Long, DeadOrbs As Long
Dim Toget As Long, NuLevelTimer As Boolean
Dim Explosive As SqueakKaBoom
Dim Orbs() As Img_Orb
Dim RegCode As String

Private Sub arena_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
If Button = 1 Then
    ' chain reaction
    If Explosive.DidClick = False Then
        PlaySound 1
        Explosive.DidClick = True
        Explosive.XCoord = x
        Explosive.YCoord = y
    End If
End If
End Sub


Private Sub Command1_Click()
' loads 50 orbs
If TotalOrbs = 0 Then TotalOrbs = 25
CreateOrbs TotalOrbs
ShowOrbs
MoveOrbs.Interval = 50
MoveOrbs.Enabled = True
End Sub

Private Sub Form_Load()
Dim x As Long
TotalOrbs = 0
arena.Cls
For x = 0 To 11
    mnu_levelset(x).Enabled = False
Next
MMControl1.Notify = False
MMControl1.Shareable = False
MMControl1.DeviceType = "WaveAudio"
MMControl1.Command = "Open"
PlaySound 4
End Sub

Private Sub ShowOrbs()
' shows all orbs on arena
Dim x As Long, CountUnMini As Long
arena.Cls ' temporary
CountUnMini = 0
For x = 0 To TotalOrbs
    arena.FillColor = Orbs(x).Color
    arena.FillStyle = 0
    arena.DrawMode = 15
    If Orbs(x).Radius > 0 Then
        arena.Circle (Orbs(x).XCoord, Orbs(x).YCoord), Orbs(x).Radius, Orbs(x).Color
    End If
    If Orbs(x).State <> 1 Then CountUnMini = CountUnMini + 1
Next
DeadOrbs = CountUnMini
' show kaboom, if it's there
arena.FillColor = RGB(255, 255, 255)
If Explosive.DidClick = True Then
    arena.DrawMode = 13
    arena.Circle (Explosive.XCoord, Explosive.YCoord), Explosive.Radius, RGB(255, 255, 255)    ' whiteboy!
End If
End Sub

Private Sub Form_Terminate()
MMControl1.Command = "Close"
End
End Sub

Private Sub Form_Unload(Cancel As Integer)
Form_Terminate
End Sub

Private Sub mnu_about_Click()
main.Enabled = False
frm_about.Show
End Sub

Private Sub mnu_assist_Click()
main.Enabled = False
frm_assist.Show
End Sub

Private Sub mnu_beep_Click()
If mnu_beep.Checked = True Then
    mnu_beep.Checked = False
Else
    mnu_beep.Checked = True
End If
End Sub

Private Sub mnu_close_Click()
Form_Terminate
End Sub

Private Sub mnu_deflection_Click()
If mnu_deflection.Checked = True Then
    mnu_deflection.Checked = False
Else
    mnu_deflection.Checked = True
End If
End Sub

Private Sub mnu_levelset_Click(Index As Integer)
Dim x As Long, y As Long
Select Case Index
    Case 0
        TotalOrbs = 5 '1
        Toget = 1
    Case 1
        TotalOrbs = 10 '2
        Toget = 2
    Case 2
        TotalOrbs = 15 '3
        Toget = 3
    Case 3
        TotalOrbs = 20 '5
        Toget = 5
    Case 4
        TotalOrbs = 25 '7
        Toget = 7
    Case 5
        TotalOrbs = 30 '10
        Toget = 10
    Case 6
        TotalOrbs = 35 '15
        Toget = 15
    Case 7
        TotalOrbs = 40 '21
        Toget = 21
    Case 8
        TotalOrbs = 45 '27
        Toget = 27
    Case 9
        TotalOrbs = 50 '33
        Toget = 33
    Case 10
        TotalOrbs = 55 '44
        Toget = 44
    Case 11
        TotalOrbs = 60 '55
        Toget = 55
End Select
For x = 0 To 11
    mnu_levelset(x).Checked = False
    mnu_levelset(x).Enabled = False
Next
For y = 0 To Index
    mnu_levelset(y).Enabled = True
Next
mnu_levelset(Index).Checked = True
Command1_Click
End Sub

Private Sub mnu_startgame_Click()
mnu_levelset_Click 0
End Sub

Private Sub MoveOrbs_Timer()
Dim x As Long, y As Long, T As Integer

For x = 0 To TotalOrbs
    ' move orbs
    If Orbs(x).State = 1 Then
        ' move orbs based on speed and angle, math is correct now
        Orbs(x).XCoord = Orbs(x).XCoord + (CosOrb(Orbs(x).angle) * Orbs(x).Speed)
        Orbs(x).YCoord = Orbs(x).YCoord - (SinOrb(Orbs(x).angle) * Orbs(x).Speed)
        ' check for stray orbs
        If (Orbs(x).XCoord <= 0) Then Orbs(x).angle = BounceLeft(Orbs(x).angle)
        If (Orbs(x).XCoord >= 550) Then Orbs(x).angle = BounceRight(Orbs(x).angle)
        If (Orbs(x).YCoord <= 0) Then Orbs(x).angle = BounceTop(Orbs(x).angle)
        If (Orbs(x).YCoord >= 400) Then Orbs(x).angle = BounceBottom(Orbs(x).angle)
    End If
    ' grow orbs
    If Orbs(x).State = 2 Then
        ' increase radius until big
        Orbs(x).Radius = Orbs(x).Radius + 2
        If Orbs(x).Radius >= 40 Then
            ' FULL!
            Orbs(x).State = 3
        End If
    End If
    
    ' kill off bloatys
    If Orbs(x).State = 3 Then
        Orbs(x).Life = Orbs(x).Life - 1
        If Orbs(x).Life = 0 Then Orbs(x).State = 4 ' shrink time!
    End If
    
    ' shrinking orbs!
    If Orbs(x).State = 4 Then
        Orbs(x).Radius = Orbs(x).Radius - 5 ' multiple of 50, go fig
        If Orbs(x).Radius <= 0 Then Orbs(x).State = 0 ' nonexistant!
    End If
Next

' see if we've kaboomed
If Explosive.DidClick = True Then
    ' test to see if were kabooming
    If (Explosive.Radius < 40) And (Explosive.Radius <> 0) And (Explosive.Life > 0) Then
        ' keep growing, else, it's DEAD! (1 kaboom per hit!  w00t)
        Explosive.Radius = Explosive.Radius + 2
    Else
        If Explosive.Life = 0 Then
            ' shrink it
            If Explosive.Radius > 0 Then
                Explosive.Radius = Explosive.Radius - 5
            End If
        Else
            ' radius = 50. take away life
            Explosive.Life = Explosive.Life - 1
        End If
    End If
End If
    
' test for an explosive collision, if existant
If Explosive.DidClick = True Then
    ' sorta like a bubble-sort
    ' test main explosive
    If Explosive.Radius > 0 Then
        For x = 0 To TotalOrbs
            If Orbs(x).State = 1 Then
                If OrbCollision(Explosive.XCoord, Explosive.YCoord, Explosive.Radius, Orbs(x).XCoord, Orbs(x).YCoord, Orbs(x).Radius) Then
                    ' there is a collision w/ the main explosive.
                    ' change state of Orb
                    Orbs(x).State = 2
                    PlaySound 1
                End If
            End If
        Next
    End If
    ' test exploded versus normal.  bubble-sort method
    For x = 0 To (TotalOrbs - 1)
        For y = (x + 1) To TotalOrbs
            ' can't test like-orbs
            If Orbs(x).State <> Orbs(y).State Then
                ' good so far, can't test two orbs at the same 'state'
                If (Orbs(x).State = 1) And (Orbs(y).State > 1) Then
                    ' one has to be mini(1) and the other alive somehow
                    If OrbCollision(Orbs(x).XCoord, Orbs(x).YCoord, Orbs(x).Radius, Orbs(y).XCoord, Orbs(y).YCoord, Orbs(y).Radius) Then
                        Orbs(x).State = 2
                        PlaySound 1
                    End If
                ElseIf (Orbs(y).State = 1) And (Orbs(x).State > 1) Then
                    ' other scenario
                    If OrbCollision(Orbs(x).XCoord, Orbs(x).YCoord, Orbs(x).Radius, Orbs(y).XCoord, Orbs(y).YCoord, Orbs(y).Radius) Then
                        Orbs(y).State = 2
                        PlaySound 1
                    End If
                End If
            End If
        Next
    Next
End If

If mnu_deflection.Checked = True Then
    ' deflection, another bubble-sort waste of time
    For x = 0 To (TotalOrbs - 1)
        For y = (x + 1) To TotalOrbs
            OrbDeflect x, y
        Next
    Next
End If

ShowOrbs
If TotalOrbs > 0 Then
    Label1.Caption = LTrim(Str(DeadOrbs)) & " / " & Format((DeadOrbs / (TotalOrbs + 1)) * 100, "##0.0") & "%"
    If LevelSelected() Then
        If Toget - DeadOrbs < 1 Then
            Label1.BackColor = "&H0000C000"
            Label1.Caption = Label1.Caption & " -- Level " & GetLevel & " Complete"
        Else
            Label1.BackColor = "&H8000000F"
            Label1.Caption = Label1.Caption & " -- Need " & LTrim(Str(Toget - DeadOrbs)) & " to complete level " & GetLevel
        End If
    Else
        Label1.BackColor = "&H8000000F"
    End If
End If

' count for endgame
' step 1: did we click?
If Explosive.DidClick = True Then
    ' step 2: is the explosive gone?
    If Explosive.Radius < 1 Then
        ' step 3: count all in states 2,3,4
        y = 0
        For x = 0 To TotalOrbs
            If Orbs(x).State = 2 Then y = y + 1
            If Orbs(x).State = 3 Then y = y + 1
            If Orbs(x).State = 4 Then y = y + 1
        Next
        If y = 0 Then
            If Not LevelSelected() Then
                ' step 4: kill timer, cause GAME IS OVER, MAN!
                For x = 0 To TotalOrbs ' show remaining
                    Orbs(x).Color = RGB(255, 255, 255)
                Next
                ShowOrbs
                MoveOrbs.Enabled = False
            Else
                ' did we complete the level?
                MoveOrbs.Enabled = False
                NuLevelTimer = False
                If DeadOrbs >= Toget Then
                    ' check for mini's, mom's recommended ending
                    ' if mini's exist, set to exploding
                    y = 0
                    For x = 0 To TotalOrbs
                        If Orbs(x).State = 1 Then
                            y = y + 1
                            Orbs(x).State = 2
                            Orbs(x).Life = 11
                        End If
                    Next
                    If y = 0 Then
                        ' now we continue, cause these orbs will be dead
                        ' got what was needed, rotate to next level
                        For x = 0 To TotalOrbs ' show remaining
                            Orbs(x).Color = RGB(0, 255, 0)
                        Next
                        ShowOrbs
                        tmr_newlevel.Interval = 1000
                        tmr_newlevel.Enabled = True
                        While NuLevelTimer = False
                            DoEvents
                        Wend
                        ' determine current level
                        For x = 0 To 11
                            If mnu_levelset(x).Checked = True Then y = x
                            mnu_levelset(x).Checked = False
                        Next
                        tmr_newlevel.Enabled = False
                        T = y + 1
                        If T < 12 Then
                            mnu_levelset(T).Checked = True
                            mnu_levelset_Click T
                            Command1_Click
                        Else
                            MsgBox "Congratulations, you have completed level 12", , "W00t"
                        End If
                    Else
                        ' emergency, restart timer
                        PlaySound 2
                        MoveOrbs.Enabled = True
                    End If ' end of explosers
                Else
                    ' restart level
                    For x = 0 To TotalOrbs ' show remaining
                        Orbs(x).Color = RGB(255, 0, 0)
                    Next
                    PlaySound 3
                    ShowOrbs
                    tmr_newlevel.Interval = 2000
                    tmr_newlevel.Enabled = True
                    While NuLevelTimer = False
                        DoEvents
                    Wend
                    tmr_newlevel.Enabled = False
                    Command1_Click
                End If
            End If
        End If
    End If
End If
End Sub

Private Function SinOrb(angle As Long) As Double
Dim Pi As Double
Pi = 3.14159265358979
SinOrb = (Sin(angle * (Pi / 180)) * Sin(angle * (Pi / 180))) * (Sgn(Sin(angle * (Pi / 180))))
End Function

Private Function CosOrb(angle As Long) As Double
Dim Pi As Double
Pi = 3.14159265358979
CosOrb = (Cos(angle * (Pi / 180)) * Cos(angle * (Pi / 180))) * (Sgn(Cos(angle * (Pi / 180))))
End Function

Private Function BounceLeft(angle As Long) As Long
BounceLeft = 1000
If (angle > 90) And (angle < 135) Then BounceLeft = 90 - (angle - 90)
If angle = 135 Then BounceLeft = 45
If (angle > 135) And (angle < 180) Then BounceLeft = 180 - angle
If angle = 180 Then BounceLeft = 0
If (angle > 181) And (angle < 224) Then BounceLeft = 360 - (angle - 180)
If angle = 225 Then BounceLeft = 315
If (angle > 226) And (angle < 269) Then BounceLeft = 270 + (270 - angle)
If BounceLeft = 1000 Then BounceLeft = angle
End Function

Private Function BounceRight(angle As Long) As Long
BounceRight = 1000
If (angle < 90) And (angle > 45) Then BounceRight = 90 + (90 - angle)
If angle = 45 Then BounceRight = 135
If (angle < 45) And (angle > 0) Then BounceRight = 180 - angle
If angle = 0 Then BounceRight = 180
If (angle < 360) And (angle > 315) Then BounceRight = 180 + (360 - angle)
If angle = 315 Then BounceRight = 225
If (angle < 315) And (angle > 270) Then BounceRight = 270 - (angle - 270)
If BounceRight = 1000 Then BounceRight = angle
End Function

Private Function BounceTop(angle As Long) As Long
BounceTop = 1000
If (angle > 0) And (angle < 45) Then BounceTop = 360 - angle
If angle = 45 Then BounceTop = 315
If (angle > 45) And (angle < 90) Then BounceTop = 270 + (90 - angle)
If angle = 90 Then BounceTop = 180
If (angle > 90) And (angle < 135) Then BounceTop = 270 - (angle - 90)
If angle = 135 Then BounceTop = 225
If (angle > 135) And (angle < 180) Then BounceTop = 180 + (180 - angle)
If BounceTop = 1000 Then BounceTop = angle
End Function

Private Function BounceBottom(angle As Long) As Long
BounceBottom = 1000
If (angle < 360) And (angle > 315) Then BounceBottom = 360 - angle
If angle = 315 Then BounceBottom = 45
If (angle < 315) And (angle > 270) Then BounceBottom = 90 - (angle - 270)
If angle = 270 Then BounceBottom = 90
If (angle < 270) And (angle > 225) Then BounceBottom = 90 + (270 - angle)
If angle = 225 Then BounceBottom = 45
If (angle < 225) And (angle > 180) Then BounceBottom = 180 - (angle - 180)
If BounceBottom = 1000 Then BounceBottom = angle
End Function

Private Sub CreateOrbs(count As Long)
Dim x As Long, y As Long, Colliding As Boolean
TotalOrbs = count
ReDim Orbs(TotalOrbs) As Img_Orb
Randomize Timer
For x = 0 To TotalOrbs
    ' make sure two orbs do not take up the same space
    Do
        Colliding = False
        Orbs(x).XCoord = Int(Rnd * 550) + 1
        Orbs(x).YCoord = Int(Rnd * 400) + 1
        Orbs(x).Radius = 7
        If x > 0 Then
            For y = 0 To (x - 1)
                If OrbCollision(Orbs(x).XCoord, Orbs(x).YCoord, Orbs(x).Radius + 1, Orbs(y).XCoord, Orbs(y).YCoord, Orbs(y).Radius + 1) Then
                    Colliding = True
                End If
            Next
        End If
    Loop While (Colliding = True)
    Do
        Orbs(x).angle = Int(Rnd * 359)
    Loop While (Orbs(x).angle Mod 90 = 0) ' no straighties
    Orbs(x).Speed = 3
    Orbs(x).Color = RGB(Int(Rnd * 255), Int(Rnd * 255), Int(Rnd * 255))
    Orbs(x).State = 1
    Orbs(x).Life = 21 ' +1 because of routine
Next
' negate kaboom, initialize it
Explosive.DidClick = False
Explosive.Radius = 2
Explosive.Life = 20
End Sub

Private Function OrbCollision(x1 As Long, y1 As Long, r1 As Long, x2 As Long, y2 As Long, r2 As Long) As Boolean
Dim OrbDist As Double
' if the two objects occupy any similar space, then it's a collision
' step 1, get distance between the two central points
OrbDist = Sqr(((x2 - x1) ^ 2) + ((y2 - y1) ^ 2))
' step 2, simple.  if the r1+r2 > orbdist, we have a collision
If (r1 + r2) >= OrbDist Then
    OrbCollision = True
Else
    OrbCollision = False
End If
End Function

Private Sub Text1_Change()
Text1.Text = Val(Text1.Text)
If Text1.Text = "0" Then Text1.Text = "50"
End Sub

Private Sub OrbDeflect(OrbA As Long, OrbB As Long)
' attempts to calculate deflection between orbs.
Dim DistOrb As Double, TempAngle As Long

' Can only deflect Orbs in mini state
If (Orbs(OrbA).State <> 1) Or (Orbs(OrbB).State <> 1) Then Exit Sub

' determine if OrbA and OrbB are close enough to deflect
DistOrb = Sqr(((Orbs(OrbB).XCoord - Orbs(OrbA).XCoord) ^ 2) + ((Orbs(OrbB).YCoord - Orbs(OrbA).YCoord) ^ 2))
If (Orbs(OrbA).Radius + Orbs(OrbB).Radius + 2) < DistOrb Then Exit Sub

' try brians first idea, swap angles... :P
TempAngle = Orbs(OrbA).angle
Orbs(OrbA).angle = Orbs(OrbB).angle
Orbs(OrbB).angle = TempAngle
End Sub

Private Function LevelSelected() As Boolean
Dim x As Long
For x = 0 To 11
    If mnu_levelset(x).Checked = True Then
        LevelSelected = True
        Exit Function
    End If
Next
LevelSelected = False
End Function

Private Function GetLevel() As Long
Dim x As Long
For x = 0 To 11
    If mnu_levelset(x).Checked = True Then
        GetLevel = x + 1
        Exit Function
    End If
Next
GetLevel = 0
End Function

Private Sub tmr_newlevel_Timer()
NuLevelTimer = True
End Sub

Private Sub PlaySound(idx As Integer)
If mnu_beep.Checked = False Then Exit Sub
If idx = 1 Then
    MMControl1.Wait = False
    MMControl1.FileName = App.Path & "\hit.wav"
    MMControl1.Command = "Sound"
ElseIf idx = 2 Then
    MMControl1.Wait = False
    MMControl1.FileName = App.Path & "\ok.wav"
    MMControl1.Command = "Sound"
ElseIf idx = 3 Then
    MMControl1.Wait = False
    MMControl1.FileName = App.Path & "\nope.wav"
    MMControl1.Command = "Sound"
ElseIf idx = 4 Then
    MMControl1.Wait = False
    MMControl1.FileName = App.Path & "\ouvrez.wav"
    MMControl1.Command = "Sound"
End If
End Sub
