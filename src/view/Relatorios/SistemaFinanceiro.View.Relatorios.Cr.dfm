inherited frmRelCr: TfrmRelCr
  Caption = 'frmRelCr'
  ClientHeight = 441
  ClientWidth = 774
  TextHeight = 15
  inherited RLReport: TRLReport
    Borders.Sides = sdCustom
    DataSource = DataSourceCr
    DefaultFilter = nil
    inherited rlbTitulo: TRLBand
      inherited rllblTitulo: TRLLabel
        Left = 227
        Width = 262
        Caption = 'Rela'#231#227'o Contas a Receber'
        ExplicitLeft = 227
        ExplicitWidth = 262
      end
    end
    inherited rlbNomeColunas: TRLBand
      object rllblValorParcela: TRLLabel
        Left = 645
        Top = 3
        Width = 41
        Height = 18
        Caption = 'Valor'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object rllblId: TRLLabel
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
      object rllblCodCliente: TRLLabel
        Left = 236
        Top = 2
        Width = 34
        Height = 18
        Caption = 'Cod'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object rllblVencimento: TRLLabel
        Left = 453
        Top = 3
        Width = 60
        Height = 18
        Caption = 'Dt Venc'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object rllblParcela: TRLLabel
        Left = 528
        Top = 3
        Width = 37
        Height = 18
        Caption = 'Parc'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object rllblStatus: TRLLabel
        Left = 568
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
      object rllblDescricao: TRLLabel
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
      object lblDataVenda: TRLLabel
        Left = 378
        Top = 3
        Width = 70
        Height = 18
        Caption = 'Dt Venda'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object rlblNomeCli: TRLLabel
        Left = 275
        Top = 3
        Width = 53
        Height = 18
        Caption = 'Cliente'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
    end
    inherited rlbDados: TRLBand
      object rldbtValorParc: TRLDBText
        Left = 645
        Top = 1
        Width = 70
        Height = 18
        AutoSize = False
        DataField = 'valor_parcela'
        DataSource = DataSourceCr
        DisplayMask = 'R$ #,##0.00'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Text = ''
      end
      object rldbtId: TRLDBText
        Left = 0
        Top = 1
        Width = 34
        Height = 18
        Align = faCenterLeft
        AutoSize = False
        DataField = 'id'
        DataSource = DataSourceCr
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Text = ''
      end
      object rldbtDataVenc: TRLDBText
        Left = 453
        Top = 1
        Width = 70
        Height = 18
        AutoSize = False
        DataField = 'data_Vencimento'
        DataSource = DataSourceCr
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Text = ''
      end
      object rldbtParcela: TRLDBText
        Left = 528
        Top = 1
        Width = 36
        Height = 18
        Alignment = taCenter
        AutoSize = False
        DataField = 'QTDPARC'
        DataSource = DataSourceCr
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Text = ''
      end
      object rldbtStatus: TRLDBText
        Left = 568
        Top = 1
        Width = 74
        Height = 18
        AutoSize = False
        DataField = 'status'
        DataSource = DataSourceCr
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Text = ''
      end
      object rldbCodFornec: TRLDBText
        Left = 232
        Top = 2
        Width = 37
        Height = 18
        Alignment = taRightJustify
        AutoSize = False
        DataField = 'ID_CLIENTE'
        DataSource = DataSourceCr
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Text = ''
      end
      object rldbtDescricao: TRLDBText
        Left = 39
        Top = 1
        Width = 194
        Height = 18
        AutoSize = False
        DataField = 'DESCRICAO'
        DataSource = DataSourceCr
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Text = ''
      end
      object rldbDataVenda: TRLDBText
        Left = 378
        Top = 1
        Width = 70
        Height = 18
        AutoSize = False
        DataField = 'DATA_VENDA'
        DataSource = DataSourceCr
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Text = ''
      end
      object rldbtNomeCli: TRLDBText
        Left = 275
        Top = 1
        Width = 100
        Height = 18
        AutoSize = False
        DataField = 'NOME'
        DataSource = DataSourceCr
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Text = ''
      end
    end
    inherited rlbRodape: TRLBand
      Top = 216
      Borders.DrawBottom = True
      ExplicitTop = 216
      inherited rlsiData: TRLSystemInfo
        Top = 21
        ExplicitTop = 21
      end
      inherited rlsiHora: TRLSystemInfo
        Top = 21
        ExplicitTop = 21
      end
      inherited rllblNomeUser: TRLLabel
        Top = 21
        Width = 4
        ExplicitTop = 21
        ExplicitWidth = 4
      end
    end
    object RLBand1: TRLBand
      Left = 39
      Top = 185
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
  object DataSourceCr: TDataSource [1]
    Left = 640
    Top = 336
  end
end
