unit DelphiCopilot.View.Dialog;

interface

uses
  Winapi.Windows,
  System.SysUtils,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.ImgList,
  Vcl.Dialogs,
  DelphiCopilot.Types,
  Vcl.ClipBrd,
  Vcl.Menus,
  System.ImageList;

type
  TDelphiCopilotViewDialog = class(TForm)
    pnButtons: TPanel;
    btnOK: TButton;
    pnTop: TPanel;
    pnDetailsLabel: TPanel;
    pnDetails: TPanel;
    mmDetails: TMemo;
    lbViewDetails: TLabel;
    btnCancel: TButton;
    pnImg: TPanel;
    ImageList1: TImageList;
    imgImageMsg: TImage;
    Panel1: TPanel;
    lbMsg: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    lbViewDetails02: TLabel;
    PopupMenu1: TPopupMenu;
    Copy1: TMenuItem;
    N1: TMenuItem;
    ShowAll1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lbViewDetailsClick(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure ShowAll1Click(Sender: TObject);
  private
    FMsg: string;
    FDetails: string;
    FButtons: TC4DButtons;
    FIcon: TC4DWizardIcon;
    FBtnFocu: TC4DBtnFocu;
    procedure DefaultValues;
    procedure ConfHeightForm;
    procedure ConfButtons;
  public
    property Msg: string write FMsg;
    property Details: string write FDetails;
    property Icon: TC4DWizardIcon write FIcon;
    property Buttons: TC4DButtons write FButtons;
    property BtnFocu: TC4DBtnFocu write FBtnFocu;
  end;

var
  DelphiCopilotViewDialog: TDelphiCopilotViewDialog;

implementation

uses
  DelphiCopilot.Utils.OTA;

{$R *.dfm}

procedure TDelphiCopilotViewDialog.FormCreate(Sender: TObject);
begin
  Self.DefaultValues;
  TDelphiCopilotUtilsOTA.IDEThemingAll(TDelphiCopilotViewDialog, Self);
  Self.Constraints.MinHeight := pnTop.Height + (pnButtons.Height * 2) + 3;
  Self.Constraints.MinWidth := Self.Width;
end;

procedure TDelphiCopilotViewDialog.FormShow(Sender: TObject);
begin
  imgImageMsg.Picture := nil;
  ImageList1.GetIcon(Integer(FIcon), imgImageMsg.Picture.Icon);

  Self.ModalResult := mrCancel;
  Self.ConfButtons;
  lbMsg.Caption := FMsg;
  mmDetails.Visible := False;
  mmDetails.Lines.Clear;
  mmDetails.Lines.Add(FDetails);
  Self.ConfHeightForm;
end;

procedure TDelphiCopilotViewDialog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Self.DefaultValues;
end;

procedure TDelphiCopilotViewDialog.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case(Key)of
    VK_F4:
    if(ssAlt in Shift)then
      Key := 0;
    VK_ESCAPE:
    if(Shift = [])then
    begin
      if(btnCancel.Visible)then
        btnCancel.Click
      else
        Self.Close;
    end;
  end;
end;

procedure TDelphiCopilotViewDialog.DefaultValues;
begin
  FMsg := '';
  FDetails := '';
  FButtons := TC4DButtons.OK;
  FIcon := TC4DWizardIcon.Information;
end;

procedure TDelphiCopilotViewDialog.ConfHeightForm;
begin
  pnDetailsLabel.Visible := True;
  pnDetails.Visible := True;
  if(FDetails.Trim.IsEmpty)then
  begin
    pnDetailsLabel.Visible := False;
    pnDetails.Visible := False;
  end;
  Self.Height := 0;
end;

procedure TDelphiCopilotViewDialog.Copy1Click(Sender: TObject);
begin
  Clipboard.AsText := lbMsg.Caption;
end;

procedure TDelphiCopilotViewDialog.ConfButtons;
begin
  btnCancel.Visible := FButtons = TC4DButtons.OK_Cancel;
  btnOK.SetFocus;
  if(btnCancel.Visible)and(FBtnFocu = TC4DBtnFocu.Cancel)then
    btnCancel.SetFocus;
end;

procedure TDelphiCopilotViewDialog.lbViewDetailsClick(Sender: TObject);
begin
  try
    if(mmDetails.Visible)then
    begin
      mmDetails.Visible := False;
      lbViewDetails02.Caption := '>>';
      Self.Height := Self.Constraints.MinHeight;
    end
    else
    begin
      mmDetails.Visible := True;
      lbViewDetails02.Caption := '<<';
      Self.Height := Self.Constraints.MinHeight * 2;
    end;
  except
  end;
  Self.Refresh;
  Self.Repaint;
end;

procedure TDelphiCopilotViewDialog.ShowAll1Click(Sender: TObject);
begin
   ShowMessage(lbMsg.Caption);
end;

procedure TDelphiCopilotViewDialog.btnCancelClick(Sender: TObject);
begin
  Self.Close;
  Self.ModalResult := mrCancel;
end;

procedure TDelphiCopilotViewDialog.btnOKClick(Sender: TObject);
begin
  Self.Close;
  Self.ModalResult := mrOK;
end;

end.
