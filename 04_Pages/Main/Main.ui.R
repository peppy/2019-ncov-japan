fluidPage(
  Component.Notification(
    status = "danger",
    context = paste0(
      "1. 当サイト使っているサーバーの性能が限られているため、一部のキャッシュをブラウザーに保存しております。",
      "画面表示がおかしくなったり、数値が更新されていない場合はリロードまたはキャッシュをクリアして再度アクセスしてください。",
      "2. 5月9日から、厚労省のデータの発表基準が大きく変更されたため、感染者数および死亡者数以外の数値に全部対応する必要があります。対応完了するまでは退院者数、検査数などのデータが更新されませんのでご注意ください。"
    )
  ),
  # メイン部分、Valueboxを含むなど
  source(
    file = paste0(COMPONENT_PATH, "/Main/FirstRow.ui.R"),
    local = T,
    encoding = "UTF-8"
  )$value,
  fluidRow(
    boxPlus(
      title = tagList(
        icon("map-marked-alt"),
        i18n$t("各都道府県の状況")
      ),
      closable = F,
      collapsible = T,
      width = 12,
      tabsetPanel(
        # 感染マップ、都道府県の情況のテーブル
        source(
          file = paste0(COMPONENT_PATH, "/Main/ConfirmedMap.ui.R"),
          local = T,
          encoding = "UTF-8"
        )$value,
        # 各都道府県の比較
        source(
          file = paste0(COMPONENT_PATH, "/Main/ComparePref.ui.R"),
          local = T,
          encoding = "UTF-8"
        )$value,
        # 感染者数ヒートマップ
        tabPanel(
          title = tagList(icon("th"), i18n$t("感染者数ヒートマップ")),
          fluidRow(
            column(width = 9,
                   uiOutput("confirmedHeatmapWrapper") %>% withSpinner(proxy.height = "600px")
            ),
            column(width = 3,
                   tags$div(
                     radioGroupButtons(
                       inputId = "confirmedHeatmapSelector",
                       label = i18n$t("ヒートマップ選択"),
                       size = "sm", justified = T,
                       choiceNames = c(i18n$t("日次新規"), i18n$t("倍加時間")),
                       choiceValues = list("confirmedHeatmap", "confirmedHeatmapDoublingTime"), 
                       status = "danger"
                     ),
                     style = "margin-top:5px;"
                   ),
                   uiOutput("confirmedHeatmapDoublingTimeOptions")
            )
          )
        ),
        # 市レベルの感染者数
        tabPanel(
          title = tagList(icon("grip-horizontal"), i18n$t("市区町村の感染者数")),
          echarts4rOutput("confirmedCityTreemap", height = "600px") %>% withSpinner()
        )
      ),
      tags$hr(),
      # 各カテゴリの合計と増加分表示の説明ブロック
      source(
        file = paste0(COMPONENT_PATH, "Main/DescriptionValue.ui.R"),
        local = T,
        encoding = "UTF-8"
      )$value,
      footer = tags$small(paste(
        i18n$t("更新時刻"), UPDATE_DATETIME, i18n$t("開発＆調整中")
      ))
    ),
  ),
  fluidRow(
    Component.Tendency()
  ),
  fluidRow(
    Component.ComfirmedPyramid(),
    Component.SymptomsProgression()
  ),
  fluidRow(
    Component.NewsList(),
    Button.clusterTab(),
  )
)