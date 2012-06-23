class Searcher
  def initialize(move_finder, evaluator)
    @move_finder = move_finder
    @evaluator = evaluator
  end

  def search(state, params)
    search_and_eval(state,params)[0]
  end

  def search_and_eval(state, params)
    depth = params[:depth]
    min = params[:min]

    if depth == 0
      return [nil, @evaluator.evaluate(state)]
    end

    best_eval = -10000
    best_move = nil
    @move_finder.find(state).each do |move|
      result = move.result

      eval = (min ? -1 : 1) *
        search_and_eval(result, params.merge(:min => !min, :depth => depth-1))[1]

      if eval > best_eval
        best_move = move
        best_eval = eval
      end
    end
    return [best_move, (min ? -1 : 1) * best_eval]
  end
end
