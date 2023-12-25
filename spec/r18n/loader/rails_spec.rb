# frozen_string_literal: true

describe R18n::Loader::Rails do
  subject(:loader) { described_class.new }

  before do
    I18n.load_path = [simple_files]
  end

  describe 'available locales' do
    subject { loader.available }

    it { is_expected.to contain_exactly(DECH, EN, RU) }
  end

  describe 'loading translation' do
    subject { loader.load(locale) }

    context 'with simple locale' do
      let(:locale) { RU }

      it { is_expected.to eq('one' => 'Один', 'two' => 'Два') }

      context 'with additional pluralization files' do
        before do
          I18n.load_path = [pl_files]
        end

        let(:expected_result) do
          {
            'users' => R18n::Typed.new(
              'pl',
              0 => 'Ноль',
              1 => 'Один',
              2 => 'Несколько',
              'n' => 'Много'
            )
          }
        end

        it { is_expected.to eq expected_result }
      end

      context 'when `load_path` changes' do
        let!(:original_hash) { loader.hash }

        before do
          I18n.load_path << other_files
        end

        describe 'reloading translations' do
          it { is_expected.to eq 'one' => 'Один', 'two' => 'Два', 'three' => 'Три' }
        end

        describe 'changing hash' do
          subject { loader.hash }

          it { is_expected.not_to eq original_hash }
        end
      end
    end

    context 'with dialect locale' do
      let(:locale) { DECH }

      it { is_expected.to eq('a' => 1) }
    end

    context 'with custom pluralization in locale' do
      let(:locale) { EN }

      let(:expected_result) do
        {
          'users' => R18n::Typed.new(
            'pl',
            0 => 'Zero',
            1 => 'One',
            2 => 'Few',
            'n' => 'Other'
          )
        }
      end

      it { is_expected.to eq expected_result }
    end
  end
end
