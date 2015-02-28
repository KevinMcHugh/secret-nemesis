require 'spec_helper'
class ConventionalBrain < Brain
  class SpyBrain < ConventionalBrain
  end
  class ResistanceBrain < ConventionalBrain
  end
end
class SingleBrain < Brain
  def self.spy_class; self::OnlyBrain; end
  def self.resistance_class; self::OnlyBrain; end
  class OnlyBrain < SingleBrain
  end
end
describe Brain do
  describe '#new_for' do
    subject { brain_class.new_for(role) }
    context 'a conventional brain' do
      let(:brain_class) { ConventionalBrain }
      context 'for a spy' do
        let(:role) { 'spy' }
        it 'returns a SpyBrain' do
          expect(subject).to be_a(ConventionalBrain::SpyBrain)
        end
      end
      context 'for a resistance' do
        let(:role) { 'resistance' }
        it 'returns a ResistanceBrain' do
          expect(subject).to be_a(ConventionalBrain::ResistanceBrain)
        end
      end
    end
    context 'a single-implementation brain' do
      let(:brain_class) { SingleBrain }
      context 'for a spy' do
        let(:role) { 'spy' }
        it 'returns an OnlyBrain' do
          expect(subject).to be_a(SingleBrain::OnlyBrain)
        end
      end
      context 'for a resistance' do
        let(:role) { 'resistance' }
        it 'returns an OnlyBrain' do
          expect(subject).to be_a(SingleBrain::OnlyBrain)
        end
      end
    end
  end
end
