VERSION 5.00
Begin VB.Form frm_assist 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Quick Help"
   ClientHeight    =   3960
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   5295
   ClipControls    =   0   'False
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3960
   ScaleWidth      =   5295
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.TextBox Text1 
      BackColor       =   &H80000000&
      Height          =   3255
      Left            =   120
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      TabIndex        =   1
      Text            =   "frm_assist.frx":0000
      Top             =   120
      Width           =   5055
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Lemme Play!"
      Height          =   375
      Left            =   120
      TabIndex        =   0
      Top             =   3480
      Width           =   5055
   End
End
Attribute VB_Name = "frm_assist"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()
frm_assist.Hide
main.Enabled = True
main.SetFocus
End Sub
