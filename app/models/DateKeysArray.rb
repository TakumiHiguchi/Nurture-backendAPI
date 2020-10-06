
class DateKeysArray
  def createDateKeysArray(array, date)
    #そもそもハッシュでやればいいのでは？説。むしろハッシュでやるべき
    #フロントの影響力が激しいのでフロントのリファクタリング時に一緒にやる

    #年の作成
    reIns = array[date.strftime("%Y").to_i]
    if reIns.nil?
        array[date.strftime("%Y").to_i] ={}
        reIns = array[date.strftime("%Y").to_i]
    end
    #月の作成
    reIns1 = reIns[date.strftime("%m").to_i]
    if reIns1.nil?
        array[date.strftime("%Y").to_i][date.strftime("%m").to_i] = {}
        reIns1 = array[date.strftime("%Y").to_i][date.strftime("%m").to_i]
    end
    #日の作成
    reIns2 = reIns1[date.strftime("%d").to_i]
    if reIns2.nil?
        array[date.strftime("%Y").to_i][date.strftime("%m").to_i][date.strftime("%d").to_i] = []
        reIns2 = array[date.strftime("%Y").to_i][date.strftime("%m").to_i][date.strftime("%d").to_i]
    end
    return array
  end
end
