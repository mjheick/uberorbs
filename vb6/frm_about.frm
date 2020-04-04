VERSION 5.00
Begin VB.Form frm_about 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "About..."
   ClientHeight    =   4530
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   5310
   ClipControls    =   0   'False
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4530
   ScaleWidth      =   5310
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton Command1 
      Caption         =   "Lemme Play!"
      Height          =   375
      Left            =   120
      TabIndex        =   1
      Top             =   4080
      Width           =   5055
   End
   Begin VB.TextBox Text1 
      BackColor       =   &H80000000&
      Height          =   3855
      Left            =   120
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      TabIndex        =   0
      Text            =   "frm_about.frx":0000
      Top             =   120
      Width           =   5055
   End
End
Attribute VB_Name = "frm_about"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()
frm_about.Hide
main.Enabled = True
main.SetFocus
End Sub
