# frozen_string_literal: true

describe R18n::Backend do
  before do
    I18n.load_path = [general_files]
    I18n.backend = described_class.new
    R18n.default_places = R18n::Loader::Rails.new
    R18n.set('en')
  end

  it 'returns available locales' do
    expect(I18n.available_locales).to match_array(%i[en ru])
  end

  describe 'objects localization' do
    describe 'time' do
      let(:time) { Time.at(0).utc }

      context 'with default format' do
        subject { I18n.l(time) }

        it { is_expected.to eq 'Thu, 01 Jan 1970 00:00:00 +0000' }
      end

      context 'with short format' do
        subject { I18n.l(time, format: :short) }

        it { is_expected.to eq '01 Jan 00:00' }
      end

      context 'with full format' do
        subject { I18n.l(time, format: :full) }

        it { is_expected.to eq '1st of January, 1970 00:00' }
      end
    end

    describe 'date' do
      subject { I18n.l(date) }

      let(:date) { Date.parse('1970-01-01') }

      it { is_expected.to eq '1970-01-01' }
    end

    describe 'float' do
      subject { I18n.l(float) }

      let(:float) { -5000.5 }

      it { is_expected.to eq '−5,000.5' }
    end
  end

  describe 'translation by key and scope' do
    context 'with key as string and without scope' do
      subject { I18n.t('in.another.level') }

      it { is_expected.to eq 'Hierarchical' }
    end

    context 'with key as simple symbol and with scope as nested path' do
      subject { I18n.t(:level, scope: 'in.another') }

      it { is_expected.to eq 'Hierarchical' }
    end

    context 'with key as nested path and with simple scope' do
      subject { I18n.t(:'another.level', scope: 'in') }

      it { is_expected.to eq 'Hierarchical' }
    end
  end

  describe 'pluralization' do
    subject { I18n.t('users', count: count) }

    context 'when count is 0' do
      let(:count) { 0 }

      it { is_expected.to eq '0 users' }
    end

    context 'when count is 1' do
      let(:count) { 1 }

      it { is_expected.to eq '1 user' }
    end

    context 'when count is 5' do
      let(:count) { 5 }

      it { is_expected.to eq '5 users' }
    end
  end

  it 'uses another separator' do
    expect(I18n.t('in/another/level', separator: '/')).to eq 'Hierarchical'
  end

  it 'translates array' do
    expect(I18n.t(['in.another.level', 'in.default'])).to eq %w[Hierarchical Default]
  end

  describe 'default option' do
    context 'with literal value' do
      subject { I18n.t(:missed, default: 'Default') }

      it { is_expected.to eq 'Default' }
    end

    context 'with single key value' do
      context 'with scope as option' do
        ## Just check the functionallity. Also, I don't know how to do it with `'in.missed'`.
        # rubocop:disable Rails/DotSeparatedKeys
        subject { I18n.t(:missed, default: :default, scope: :in) }
        # rubocop:enable Rails/DotSeparatedKeys

        it { is_expected.to eq 'Default' }
      end

      context 'with scope in key', pending: 'We should extract scope from key for default' do
        subject { I18n.t(:'in.missed', default: :default) }

        it { is_expected.to eq 'Default' }
      end
    end

    context 'with array of keys value' do
      subject { I18n.t(:missed, default: %i[also_no in.default]) }

      it { is_expected.to eq 'Default' }
    end

    context 'with proc value' do
      subject { I18n.t(:missed, default: proc { |key| key.to_s }) }

      it { is_expected.to eq 'missed' }
    end
  end

  describe 'error on missing translation' do
    context 'with full call' do
      subject(:call) { I18n.backend.translate(:en, :missed) }

      specify do
        expect { call }.to raise_error(I18n::MissingTranslationData)
      end
    end

    context 'with shortcat call' do
      subject(:call) { I18n.t(:missed) }

      specify do
        expect { call }.to raise_error(I18n::MissingTranslationData)
      end
    end
  end

  ## https://github.com/rubocop-hq/rubocop/issues/7436#issuecomment-578766498
  # rubocop:disable Style/FormatStringToken
  describe 'reserved keys are not using as variables' do
    describe 'scope key' do
      subject { I18n.t(:scope, scope: 'reserved_keys') }

      it { is_expected.to eq '%{scope} is not here' }

      context 'with missing translation' do
        subject { I18n.t(:missed, default: %i[scope], scope: 'reserved_keys') }

        it { is_expected.to eq '%{scope} is not here' }
      end
    end

    describe 'default key' do
      subject { I18n.t('reserved_keys.default', default: 'it is default') }

      it { is_expected.to eq '%{default} is not used' }

      context 'with missing translation' do
        subject { I18n.t(:missed, default: %i[reserved_keys.default]) }

        it { is_expected.to eq '%{default} is not used' }

        context 'when value is proc' do
          subject do
            I18n.t(:missed, default: ->(key, options) { "#{key}, #{options}" }, scope: 'in')
          end

          let(:expected_value) do
            if Gem::Version.new(RUBY_VERSION) < Gem::Version.new('4.0.0')
              'missed, {:scope=>"in"}'
            else
              'missed, {scope: "in"}'
            end
          end

          it { is_expected.to eq expected_value }
        end
      end
    end

    describe 'separator key' do
      subject { I18n.t('reserved_keys/separator', separator: '/') }

      it { is_expected.to eq '%{separator} is not used' }

      context 'with missing translation' do
        subject { I18n.t(:missed, default: %i[reserved_keys/separator], separator: '/') }

        it { is_expected.to eq '%{separator} is not used' }
      end
    end
  end
  # rubocop:enable Style/FormatStringToken

  describe 'reloading translations' do
    subject(:call) { I18n.t(:other) }

    specify do
      expect { call }.to raise_error(I18n::MissingTranslationData)
    end

    context 'when new translations added and reloaded' do
      before do
        I18n.load_path << other_files
        I18n.reload!
      end

      it { is_expected.to eq 'Other' }
    end
  end

  describe 'returning plain classes' do
    describe 'an end-point' do
      subject { I18n.t('in.another.level').class }

      context 'with ActiveSupport::SafeBuffer' do
        before do
          ActiveSupport::SafeBuffer if ActiveSupport.autoload?(:SafeBuffer)
        end

        it { is_expected.to eq ActiveSupport::SafeBuffer }
      end

      context 'without ActiveSupport::SafeBuffer' do
        before do
          ## I don't know how to correctly rework this
          # rubocop:disable RSpec/AnyInstance
          allow_any_instance_of(R18n::TranslatedString)
            .to receive(:respond_to?).with(:html_safe).and_return false
          # rubocop:enable RSpec/AnyInstance
        end

        it { is_expected.to eq String }
      end
    end

    describe 'not an end-point' do
      subject { I18n.t('in.another').class }

      it { is_expected.to eq Hash }
    end
  end

  ## https://github.com/rubocop-hq/rubocop/issues/7436#issuecomment-578766498
  # rubocop:disable Style/FormatStringToken
  it 'returns correct unpluralized hash' do
    expect(I18n.t('users')).to eq(one: '1 user', other: '%{count} users')
  end
  # rubocop:enable Style/FormatStringToken

  describe 'correct deep untranslated' do
    context 'with simple untranslated' do
      subject(:call) { I18n.t('in.another.level.deeper') }

      specify do
        expect { call }.to raise_error(I18n::MissingTranslationData)
      end
    end

    context 'when path is deeper than untranslated' do
      subject(:call) { I18n.t('in.another.level.go.deeper') }

      specify do
        expect { call }.to raise_error(I18n::MissingTranslationData)
      end
    end
  end

  it "doesn't call String methods" do
    expect(I18n.t('in.another').class).to eq Hash
  end

  it "doesn't call object methods" do
    expect { I18n.t('in.another.level.to_sym') }.to raise_error(I18n::MissingTranslationData)
  end

  it 'works deeper pluralization' do
    expect(I18n.t('users.other', count: 5)).to eq '5 users'
  end

  it 'returns hash with symbols keys' do
    expect(I18n.t('in')).to eq(
      another: { level: 'Hierarchical' },
      default: 'Default'
    )
  end

  describe 'changing locale in place' do
    before do
      I18n.load_path << pl_files
    end

    context 'without locale option' do
      describe 'pluralization' do
        subject { I18n.t('users', count: 5) }

        it { is_expected.to eq '5 users' }
      end

      describe 'date format' do
        subject { I18n.l(Date.parse('1970-01-01')) }

        it { is_expected.to eq '1970-01-01' }
      end
    end

    context 'with locale option' do
      describe 'pluralization' do
        subject { I18n.t('users', count: 5, locale: :ru) }

        it { is_expected.to eq 'Много' }
      end

      describe 'date format' do
        subject { I18n.l(Date.parse('1970-01-01'), locale: :ru) }

        it { is_expected.to eq '01.01.1970' }
      end
    end
  end

  it 'has transliterate method' do
    expect(I18n.transliterate('café')).to eq 'cafe'
  end
end
