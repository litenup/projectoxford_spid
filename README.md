# ProjectoxfordSpid

Ruby wrapper for Microsoft Project Oxford [Speaker Identification API](https://dev.projectoxford.ai/docs/services/563309b6778daf02acc0a508/operations/5645c3271984551c84ec6797) (note: verification API not yet supported)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'projectoxford_spid'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install projectoxford_spid

## Usage

### Authorization
```ruby
client = ProjectoxfordSpid::RestAPI.new subscription_key
```

### Profiles
```ruby
client.create_profile
client.get_profiles
client.get_profile(identification_profile_id)
client.delete_profile(identification_profile_id)
```

### Enrollment
```ruby
client.reset_enrollment(identification_profile_id)
client.get_operation_status(operation_id)
```

#### create_enrollment
create_enrollment method takes in options for audio manipulation, [AudioHero](https://github.com/litenup/audio_hero) gem and [SoX](http://sox.sourceforge.net/) are required for audio manipulation to work.

Options:
* Convert - perform audio format conversation, convert options are passed directly to AudioHero.
* Remove silence - remove silence in audio file, remove_silence options are passed directly to AudioHero

```ruby
client.create_enrollment(identification_profile_id, file_location, options)

# example - convert stereo mp3 to mono wav(use left channel only) and remove silence before sending it to Microsoft API.
client.create_enrollment("identification_profile_id", "https://s3.amazonaws.com/recording.mp3", {convert: {channel: "left", gc: "true"}, remove_silence: {input_format: "wav", gc: "true"}})
```

### Identification
Same as enrollment, options are avaiable for audio manipulation
Options:
* Convert - perform audio format conversation, convert options are passed directly to AudioHero.
* Remove silence - remove silence in audio file, remove_silence options are passed directly to AudioHero

```ruby
client.identification(identification_profile_ids, file_location, options={})
# example
client.identification(["profile_id1", "profile_id2"], "https://s3.amazonaws.com/recording.mp3", {convert: {channel: "left", gc: "true", default: "true"}, remove_silence: {input_format: "wav", gc: "true"}})
```

### Verification
Not Yet Supported

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/projectoxford_spid. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

