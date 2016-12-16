require 'spec_helper'

module SvatokCodebreaker
  RSpec.describe Marker do
    context '#marking_guess' do
      array = [['1234', '1234', '++++'],
      ['4444', '4444', '++++'],
      ['3331', '3332', '+++'],
      ['1113', '1112', '+++'],
      ['1312', '1212', '+++'],
      ['1234', '1266', '++'],
      ['1234', '6634', '++'],
      ['1234', '1654', '++'],
      ['1234', '1555', '+'],
      ['1234', '4321', '----'],
      ['5432', '2345', '----'],
      ['1234', '2143', '----'],
      ['1221', '2112', '----'],
      ['5432', '2541', '---'],
      ['1145', '6514', '---'],
      ['1244', '4156', '--'],
      ['1221', '2332', '--'],
      ['2244', '4526', '--'],
      ['5556', '1115', '-'],
      ['1234', '6653', '-'],
      ['3331', '1253', '--'],
      ['2345', '4542', '+--'],
      ['1243', '1234', '++--'],
      ['4111', '4444', '+'],
      ['1532', '5132', '++--'],
      ['3444', '4334', '+--'],
      ['1113', '2155', '+'],
      ['2245', '4125', '+--'],
      ['4611', '1466', '---'],
      ['5451', '4445', '+-'],
      ['2222', '1111', '']
    ]

    array.each do |item|
      it "responds by marking #{item[0]} to #{item[1]} = #{item[2]}" do
        marker = Marker.new(item[0], item[1])
        expect(marker.marking_guess).to eq(item[2])
      end
    end
  end

    context '#marking_exact_matches' do
      let(:marker) { Marker.new('1234', '1534') }

      it 'marking exact matches with +' do
        expect(marker.marking_exact_matches).to match(['+', nil, '+', '+'])
      end
      it 'code and guess leave without exact matchec numbers' do
        marker.marking_exact_matches
        expect(marker.instance_variable_get(:@secret_code)).to match([nil, '2', nil, nil])
        expect(marker.instance_variable_get(:@guess)).to match([nil, '5', nil, nil])
      end
    end

    context '#marking_inexact_matches' do
      it 'marking inexact matches with -' do
        marker = Marker.new('1254', '1532')
        marker.marking_exact_matches
        expect(marker.marking_inexact_matches).to match(['-', nil, '-'])
      end
    end
  end
end
