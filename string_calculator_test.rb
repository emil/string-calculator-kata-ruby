require 'minitest/autorun'
require_relative 'string_calculator'

class StringCalculatorTest < MiniTest::Test
  def setup
  end

  def test_empty_or_nil_calculates_0
    s = StringCalculator.new
    assert_equal 0, s.add(nil)
    assert_equal 0, s.add('')
  end

  def test_single_value
    sc = StringCalculator.new
    10.times {|n|
      sv = n + rand(999)
      assert_equal sv, sc.add(sv.to_s) 
    }
  end

  def test_comma_delimited_values
    sc = StringCalculator.new
    [
     ['10,12',22],
     ['20,25,25',70],
     ['50,50,125', 225]
    ].each {|s, res|

       assert_equal res, sc.add(s)
    }
  end


  def test_newline_delimited_values
    sc = StringCalculator.new
    [
     ['10\n12',22],
     ['20\n25\n25',70],
     ['50\n50\n125', 225]
    ].each {|s, res|

      assert_equal res, sc.add(s)
    }
  end

  def test_negative_raises
    sc = StringCalculator.new
    [
     ['10\n-12',22],
     ['-20\n25\n25',70],
     ['50\n-50\n125', 225]
    ].each {|s, res|

      assert_raises ArgumentError do
        sc.add(s)
      end
    }
  end

  def test_ignores_thousand
    sc = StringCalculator.new
    [
     ['10\n1200',10],
     ['20\n25\n1001',45],
     ['20\n25\n1000',1045],
     ['50\n50\n999', 1099]
    ].each {|s, res|

      assert_equal res, sc.add(s)
    }
  end

  def test_add_extra_delimiter
    sc = StringCalculator.new
    assert_equal 3, sc.add('//;\n1;2')
  end

  def test_delimiter_multiple_chars
    sc = StringCalculator.new
    assert_equal 6, sc.add('//[***]\n1***2***3')
  end

  def test_multiple_delimiters
    sc = StringCalculator.new
    assert_equal 6, sc.add('//[*][%]\n1*2%3')
  end
end
