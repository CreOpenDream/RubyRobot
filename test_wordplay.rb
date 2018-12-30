require 'rubygems'
require 'test/unit'
require 'WordPlay'
class TestWordPlay < Test::Unit::TestCase
  def test_sentences
    assert_equal(["a", "b", "c d", "e f g"],"a.b.c d.e f g".sentences)
    test_text = %q{Hello.This is a test
of sentence separation.This is the end of the test.}
    assert_equal("This is the end of the test", test_text.sentences[2])
  end

  def test_words
    assert_equal(%w{this is a test}, "this is a test".words)
    assert_equal(%w{these are mostly words}, "these are,mostly,words".words)
  end

  def test_sentence_choice
    assert_equal("This is a test",WordPlay.best_sentences(['This is a test','This is another test'],
                                                           %w{test great this}))
    assert_equal("This is a great test",
                 WordPlay.best_sentences(['This is a great test'],%w{still the best}))
  end
end