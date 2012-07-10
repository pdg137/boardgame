class Searcher
  def initialize(move_finder, evaluator)
    @move_finder = move_finder
    @evaluator = evaluator
  end

  def search(state, params)
    alpha = -10000
    best_move = nil
    @move_finder.find(state).each do |move|
      result = move.result
      eval = search_and_eval(result, alpha, 10000, params[:depth]-1, true)
      if eval > alpha
        alpha = eval
        best_move = move
      end
    end
    return best_move
  end

  def min(a,b)
    a < b ? a : b
  end

  def max(a,b)
    a > b ? a : b
  end

  # params:
  # - depth = depth to search
  # - minimizer = true if minimizing
  # - alpha = minimum possible score
  # - beta  = maximum possible score
  # returns:
  #   [ best_move, best_eval]
  def search_and_eval(state, alpha, beta, depth, minimizer)
    if depth == 0
      return @evaluator.evaluate(state)
    end

    @move_finder.find(state).each do |move|
      result = move.result
      eval = search_and_eval(result, alpha, beta, depth-1, !minimizer)

      if minimizer
        beta = min(beta, eval)
      else
        alpha = max(eval, alpha)
      end
      
      if beta <= alpha
        # the best move we found is already so good that the next level would not choose it
        break
      end
    end

    return (minimizer ? beta : alpha)
  end
end
