inherited frmRelLancamentoPadrao: TfrmRelLancamentoPadrao
  Caption = 'Rela'#231#227'o de Lan'#231'amentos Padr'#227'o'
  ClientHeight = 441
  ClientWidth = 774
  TextHeight = 15
  inherited RLReport: TRLReport
    DataSource = dsLancPadrao
    inherited rlbTitulo: TRLBand
      inherited rllblTitulo: TRLLabel
        Left = 198
        Width = 320
        Caption = 'Rela'#231#227'o de Lan'#231'amentos Padr'#227'o'
        ExplicitLeft = 198
        ExplicitWidth = 320
      end
    end
    inherited rlbNomeColunas: TRLBand
      object lblId: TRLLabel
        Left = 0
        Top = 3
        Width = 16
        Height = 18
        Align = faCenterLeft
        Caption = 'Id'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object lblDescricao: TRLLabel
        Left = 39
        Top = 3
        Width = 76
        Height = 18
        Caption = 'Descri'#231#227'o'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object lblStatus: TRLLabel
        Left = 573
        Top = 3
        Width = 48
        Height = 18
        Caption = 'Status'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object lblTipo: TRLLabel
        Left = 384
        Top = 3
        Width = 35
        Height = 18
        Caption = 'Tipo'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
    end
    inherited rlbDados: TRLBand
      object txtDescricao: TRLDBText
        Left = 39
        Top = 1
        Width = 330
        Height = 18
        AutoSize = False
        DataField = 'DESCRICAO'
        DataSource = dsLancPadrao
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Text = ''
      end
      object txtTipo: TRLDBText
        Left = 384
        Top = 1
        Width = 177
        Height = 18
        AutoSize = False
        DataField = 'TIPO'
        DataSource = dsLancPadrao
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Text = ''
        BeforePrint = txtTipoBeforePrint
      end
      object txtStatus: TRLDBText
        Left = 573
        Top = 1
        Width = 140
        Height = 18
        AutoSize = False
        DataField = 'status'
        DataSource = dsLancPadrao
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Text = ''
        BeforePrint = txtStatusBeforePrint
      end
      object txtId: TRLDBText
        Left = 0
        Top = 1
        Width = 34
        Height = 18
        Align = faCenterLeft
        AutoSize = False
        DataField = 'id'
        DataSource = dsLancPadrao
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Text = ''
      end
    end
  end
  object dsLancPadrao: TDataSource
    Left = 392
    Top = 336
  end
end
