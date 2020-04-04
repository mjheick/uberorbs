VERSION 5.00
Begin VB.Form register 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Registration"
   ClientHeight    =   1155
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   4680
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1155
   ScaleWidth      =   4680
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton command2 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   120
      TabIndex        =   3
      Top             =   720
      Width           =   1215
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Register"
      Height          =   375
      Left            =   3360
      TabIndex        =   2
      Top             =   720
      Width           =   1215
   End
   Begin VB.TextBox Text1 
      Alignment       =   2  'Center
      Height          =   285
      Left            =   120
      TabIndex        =   1
      Top             =   360
      Width           =   4455
   End
   Begin VB.Label Label1 
      Caption         =   "Please enter the registration code you were provided.  "
      Height          =   255
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   4455
   End
End
Attribute VB_Name = "register"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command2_Click()
register.Hide
main.Show
main.Enabled = True
main.SetFocus
End Sub

Private Sub Command1_Click()
If vRegistration(Text1.Text) = False Then
    MsgBox "Invalid Registration Code", , "Error"
    register.Hide
    main.Show
    main.Enabled = True
    main.SetFocus
Else
    MsgBox "Thank you for registering", , "W00t"
    SaveSetting "UberOrbs", "Settings", "RegCode", Text1.Text
    main.mnu_register.Visible = False
    register.Hide
    main.Show
    main.Enabled = True
    main.SetFocus
End If
End Sub

Public Function vRegistration(Key As String) As Boolean
Dim x As Integer, B As Byte
' registration
vRegistration = False

' STEP 1: verify length of input
'         should be 35 characters AAAAA-BBBBB-CCCCC-DDDDD-EEEEE-FFFFF
'                                 12345678901234567890123456789012345
'                                          1         2         3
If Len(Key) <> 35 Then Exit Function

' STEP 2: verify hyphens at 5, 10, 15, 20, 25
If Mid(Key, 6, 1) <> "-" Then Exit Function
If Mid(Key, 12, 1) <> "-" Then Exit Function
If Mid(Key, 18, 1) <> "-" Then Exit Function
If Mid(Key, 24, 1) <> "-" Then Exit Function
If Mid(Key, 30, 1) <> "-" Then Exit Function

' STEP 3: verify all characters are uppercase letters
For x = 1 To Len(Key)
    B = Asc(Mid(Key, x, 1))
    If ((B = &H2D) Or ((B > &H40) And (B < &H5B))) Then
        DoEvents
    Else
        ' fakeout
        Exit Function
    End If
Next

' STEP 4: Each set cannot be the same as the other, A<>BCDEF, B<>CDEF, C<>DEF, D<>EF, E<>F
If Mid(Key, 1, 5) = Mid(Key, 7, 5) Then Exit Function
If Mid(Key, 1, 5) = Mid(Key, 13, 5) Then Exit Function
If Mid(Key, 1, 5) = Mid(Key, 19, 5) Then Exit Function
If Mid(Key, 1, 5) = Mid(Key, 25, 5) Then Exit Function
If Mid(Key, 1, 5) = Mid(Key, 31, 5) Then Exit Function
If Mid(Key, 7, 5) = Mid(Key, 13, 5) Then Exit Function
If Mid(Key, 7, 5) = Mid(Key, 19, 5) Then Exit Function
If Mid(Key, 7, 5) = Mid(Key, 25, 5) Then Exit Function
If Mid(Key, 7, 5) = Mid(Key, 31, 5) Then Exit Function
If Mid(Key, 13, 5) = Mid(Key, 19, 5) Then Exit Function
If Mid(Key, 13, 5) = Mid(Key, 25, 5) Then Exit Function
If Mid(Key, 13, 5) = Mid(Key, 31, 5) Then Exit Function
If Mid(Key, 19, 5) = Mid(Key, 25, 5) Then Exit Function
If Mid(Key, 19, 5) = Mid(Key, 31, 5) Then Exit Function
If Mid(Key, 25, 5) = Mid(Key, 31, 5) Then Exit Function

' STEP 5: Verify Key
' A=C, B=D, E=F
If GetTotal(Mid(Key, 1, 5)) <> GetTotal(Mid(Key, 13, 5)) Then Exit Function
If GetTotal(Mid(Key, 7, 5)) <> GetTotal(Mid(Key, 19, 5)) Then Exit Function
If GetTotal(Mid(Key, 25, 5)) <> GetTotal(Mid(Key, 31, 5)) Then Exit Function

vRegistration = True
End Function

Private Function GetTotal(sString As String) As Long
Dim x As Long
GetTotal = 0
For x = 1 To Len(sString)
    GetTotal = GetTotal + Asc(Mid(sString, x, 1))
Next
End Function

