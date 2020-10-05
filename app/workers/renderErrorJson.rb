class RenderErrorJson
  def createError(props)
    error_base ={
      status:'ERROR',
      api_version: props[:api_version],
      error_code: props[:code]
    }
    case props[:code]
      when 'SE_0001'
        error_base[:mes] = 'サインインに失敗しました'
      when 'AE_0001'
        error_base[:mes] = 'アクセス権限がありません。ログインしてください'
      when 'AE_0002'
        error_base[:mes] = 'カレンダーへのアクセス権限がありません'
      when 'AE_0010'
        error_base[:mes] = 'カレンダーをうまく作成できませんでした'
      when 'AE_0011'
        error_base[:mes] = 'カレンダーをうまく変更できませんでした'
      when 'AE_0012'
        error_base[:mes] = 'カレンダーをうまく削除できませんでした'
      when 'AE_0013'
        error_base[:mes] = 'カレンダーをうまくコピーできませんでした'
      when 'AE_0014'
        error_base[:mes] = 'カレンダーをうまくフォローできませんでした'
      when 'AE_0015'
        error_base[:mes] = 'カレンダーをうまくアンフォローできませんでした'
      when 'AE_0020'
        error_base[:mes] = '休講をうまく登録できませんでした'
      when 'AE_0025'
        error_base[:mes] = '授業変更をうまく登録できませんでした'
      when 'AE_0026'
        error_base[:mes] = '授業変更をうまく削除できませんでした'
      when 'AE_0030'
        error_base[:mes] = '試験をうまく作成できませんでした'
      when 'AE_0031'
        error_base[:mes] = '試験をうまく更新できませんでした'
      when 'AE_0035'
        error_base[:mes] = 'スケジュールをうまく作成できませんでした'
      when 'AE_0036'
        error_base[:mes] = 'すでにそのスケジュールは登録されています'
      when 'AE_0037'
        error_base[:mes] = 'スケジュールをうまく登録できませんでした'
      when 'AE_0040'
        error_base[:mes] = 'タスクをうまく登録できませんでした'
      when 'AE_0041'
        error_base[:mes] = 'タスクをうまく更新できませんでした'
      when 'AE_0042'
        error_base[:mes] = 'タスクをうまく削除できませんでした'
      when 'AE_0100'
        error_base[:mes] = '学年が登録できませんでした'
      when 'AE_0101'
        error_base[:mes] = '学期の期間が登録できませんでした'
    end
    return JSON.pretty_generate(error_base)
  end
  
end
