class Searcher
  def initialize(move_finder, evaluator)
    @move_finder = move_finder
    @evaluator = evaluator
  end

  def search(state, params)
    search_and_eval(state,params)[0]
  end

  def search_and_eval(state, params)
    best_eval = (params[:min] ? 10000 : -10000)
    best_move = nil
    @move_finder.find(state).each do |move|
      result = move.result

      if params[:depth] == 1
        eval = @evaluator.evaluate(result)
      else
        eval = search_and_eval(result, params.merge(:min => !params[:min], :depth => params[:depth]-1))[1]
      end

      if (!params[:min] && eval > best_eval) ||
          (params[:min] && eval < best_eval)
        best_move = move
        best_eval = eval
      end
    end
    return [best_move, best_eval]
  end
end
