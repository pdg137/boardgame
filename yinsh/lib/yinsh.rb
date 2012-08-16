class YinshState
  def initalize
  end

  def []=(x, y, val)
    check_bounds(x,y)
  end

  def check_bounds(x,y)
    # simplify with symmetry

    # mirror at x=y
    x,y = y,x if y > x

    # mirror at x=6
    x,y = 12-x,y-x+6 if x > 6

    # mirror at x=y again
    x,y = y,x if y > x

    if x < 2 || y < (x==6 ? 2 : 1)
      raise OutOfBoundsException.new
    end
  end
end
