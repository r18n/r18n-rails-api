# frozen_string_literal: true

describe 'R18n::Filters' do
  describe 'using old variables syntax' do
    let(:i18n) do
      R18n::Translation.new(
        EN, '', locale: EN, translations: { 'echo' => 'Value is {{value}}' }
      )
    end

    specify do
      expect(i18n.echo(value: 'Old')).to eq 'Value is Old'
    end
  end

  # rubocop:disable Style/FormatStringToken
  describe 'pluralization by variable %{count}' do
    let(:i18n) do
      R18n::Translation.new(
        EN, '', locale: EN, translations: {
          'users' => R18n::Typed.new(
            'pl',
            0 => 'no users',
            1 => '1 user',
            'n' => '%{count} users'
          )
        }
      )
    end

    specify do
      expect(i18n.users(count: 0)).to eq 'no users'
    end

    specify do
      expect(i18n.users(count: 1)).to eq '1 user'
    end

    specify do
      expect(i18n.users(count: 5)).to eq '5 users'
    end
  end
  # rubocop:enable Style/FormatStringToken
end
