class Searcher
  def initialize(move_finder, evaluator)
    @move_finder = move_finder
    @evaluator = evaluator
  end

  def search(state, params)
    search_and_eval(state,params)[0]
  end

  # params:
  # - depth = depth to search
  # - min   = true if minimizing
  # - alpha = minimum possible score
  # - beta  = maximum possible score
  # returns:
  #   [ best_move, best_eval]
  def search_and_eval(state, params)
    depth = params[:depth]
    min = params[:min]
    alpha = params[:alpha] || -10000
    beta = params[:beta] || 10000

    if depth == 0
      return [nil, @evaluator.evaluate(state)]
    end

    best_move = nil
    @move_finder.find(state).each do |move|
      result = move.result
      eval = search_and_eval(result, params.merge(:min => !min, :depth => depth-1, :alpha => alpha, :beta => beta))[1]

      if min
        if eval < beta
          best_move = move
          beta = eval
        end
      else
        if eval > alpha
          best_move = move
          alpha = eval
        end
      end
      
      if beta <= alpha
        # the best move we found is already so good that the next level would not choose it
        break
      end
    end

    return [best_move, (min ? beta : alpha)]
  end
end
