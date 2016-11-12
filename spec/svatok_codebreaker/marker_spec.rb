require 'spec_helper'

module SvatokCodebreaker
  RSpec.describe Marker do
    context '#marking_guess' do
      it 'guess is a winning' do
        marker = Marker.new(1234, 1234)
        expect(marker.marking_guess).to eq('++++')
      end
      it 'guess has correct numbers' do
        marker = Marker.new(1234, 1534)
        expect(marker.marking_guess).to match(/^([-]{1,4}|[+]{1,3}|[+-]{1,3}[-])$/)
      end
      it 'guess does not have the right numbers' do
        marker = Marker.new(1234, 5555)
        expect(marker.marking_guess).to match('Sorry, but there is no match...')
      end
    end
  end
end
