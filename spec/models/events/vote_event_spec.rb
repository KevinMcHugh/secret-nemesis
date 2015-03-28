require 'spec_helper'

describe VoteEvent do
  let(:player1) { double('Player1', to_s: 'player1') }
  let(:player2) { double('Player2', to_s: 'player2') }
  let(:listener) { double('EventListener', notify: nil) }
  let(:team) { [player1, player2] }
  let(:players_to_votes) { { player1 => vote_passes, player2 => vote_passes }}
  let(:event) { described_class.new(listener, team, players_to_votes, vote_passes) }
  describe '#to_s' do
    subject { event.to_s }
    let(:vote_passes) { true }
    context 'a passing vote' do
      it 'shows that the vote passed' do
        expect(subject.strip).to eql("Vote passes on #{[player1, player2]}: #{players_to_votes}")
      end
    end
    context 'a failing vote' do
      let(:vote_passes) { false }
      it 'shows that the vote failed' do
        expect(subject.strip).to eql("Vote fails on #{[player1, player2]}: #{players_to_votes}")
      end
    end
  end
end
