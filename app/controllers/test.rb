require 'prawn'

def test
  Prawn::Document.generate("test.pdf") do
    font "#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf"
    text "this is a test"
  end
end
