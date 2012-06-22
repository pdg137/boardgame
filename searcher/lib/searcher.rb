class Searcher
  def initialize(move_finder, evaluator)
    @move_finder = move_finder
    @evaluator = evaluator
  end

  def search(state, params)
    max = -10000
    max_move = nil
    @move_finder.find(state).each do |move|
      result = move.result
      if @evaluator.evaluate(result) > max
        max_move = move
      end
    end
    return max_move
  end
end
