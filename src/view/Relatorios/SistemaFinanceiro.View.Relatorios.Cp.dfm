inherited frmRelCp: TfrmRelCp
  Caption = 'frmRelCp'
  ClientHeight = 442
  ClientWidth = 778
  ExplicitWidth = 790
  ExplicitHeight = 480
  TextHeight = 15
  inherited RLReport: TRLReport
    DataSource = DataSourceCp
    inherited rlbTitulo: TRLBand
      inherited rllblTitulo: TRLLabel
        Left = 239
        Width = 238
        Caption = 'Rela'#231#227'o Contas a Pagar'
        ExplicitLeft = 239
        ExplicitWidth = 238
      end
    end
    inherited rlbNomeColunas: TRLBand
      object rllblId: TRLLabel
        Left = 0
        Top = 1
        Width = 41
        Height = 22
        Align = faLeftTop
        Caption = 'Cod'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -19
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object rllblDescricao: TRLLabel
        Left = 47
        Top = 1
        Width = 91
        Height = 22
        Align = faTopOnly
        Caption = 'Descri'#231#227'o'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -19
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object rllblVencimento: TRLLabel
        Left = 318
        Top = 1
        Width = 106
        Height = 22
        Align = faTopOnly
        Caption = 'Vencimento'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -19
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object rllblParcela: TRLLabel
        Left = 430
        Top = 1
        Width = 69
        Height = 22
        Align = faTopOnly
        Caption = 'Parcela'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -19
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object rllblStatus: TRLLabel
        Left = 499
        Top = 1
        Width = 58
        Height = 22
        Align = faTopOnly
        Caption = 'Status'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -19
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object rllblValorParcela: TRLLabel
        Left = 583
        Top = 1
        Width = 118
        Height = 22
        Align = faTopOnly
        Caption = 'Valor Parcela'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -19
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object rllblCodFornec: TRLLabel
        Left = 247
        Top = 1
        Width = 65
        Height = 22
        Align = faTopOnly
        Caption = 'Fornec'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -19
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
    end
    inherited rlbDados: TRLBand
      object rldbtId: TRLDBText
        Left = 0
        Top = 0
        Width = 41
        Height = 18
        Align = faLeftTop
        AutoSize = False
        DataField = 'id'
        DataSource = DataSourceCp
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Text = ''
      end
      object rldbtDescricao: TRLDBText
        Left = 47
        Top = 0
        Width = 194
        Height = 18
        Align = faTopOnly
        AutoSize = False
        DataField = 'DESCRICAO'
        DataSource = DataSourceCp
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Text = ''
      end
      object rldbtDataVenc: TRLDBText
        Left = 310
        Top = 0
        Width = 128
        Height = 18
        Align = faTopOnly
        Alignment = taCenter
        AutoSize = False
        DataField = 'data_Vencimento'
        DataSource = DataSourceCp
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Text = ''
      end
      object rldbtParcela: TRLDBText
        Left = 437
        Top = 0
        Width = 56
        Height = 18
        Align = faTopOnly
        Alignment = taCenter
        AutoSize = False
        DataField = 'parcela'
        DataSource = DataSourceCp
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Text = ''
      end
      object rldbtStatus: TRLDBText
        Left = 503
        Top = 0
        Width = 74
        Height = 18
        Align = faTopOnly
        AutoSize = False
        DataField = 'status'
        DataSource = DataSourceCp
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Text = ''
      end
      object rldbtValorParc: TRLDBText
        Left = 599
        Top = 0
        Width = 98
        Height = 18
        Align = faTopOnly
        AutoSize = False
        DataField = 'valor_parcela'
        DataSource = DataSourceCp
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Text = ''
      end
      object rldbCodFornec: TRLDBText
        Left = 247
        Top = 0
        Width = 57
        Height = 18
        Align = faTopOnly
        Alignment = taCenter
        AutoSize = False
        DataField = 'ID_FORNECEDOR'
        DataSource = DataSourceCp
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Text = ''
      end
    end
    inherited rlbRodape: TRLBand
      Top = 181
      ExplicitTop = 181
    end
    object RLBand1: TRLBand
      Left = 39
      Top = 150
      Width = 716
      Height = 31
      BandType = btSummary
      Borders.Sides = sdCustom
      Borders.DrawLeft = False
      Borders.DrawTop = True
      Borders.DrawRight = False
      Borders.DrawBottom = True
      object rllblTotal: TRLLabel
        Left = 598
        Top = 7
        Width = 44
        Height = 19
        Alignment = taCenter
        Caption = 'Valor'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object rllblContador: TRLLabel
        Left = 0
        Top = 6
        Width = 83
        Height = 19
        Align = faCenterLeft
        Caption = 'Contagem'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
  end
  object DataSourceCp: TDataSource
    Left = 584
    Top = 344
  end
end
