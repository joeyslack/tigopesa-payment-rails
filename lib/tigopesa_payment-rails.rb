# This is the main Tigopesa driver
class TigopesaPaymentRails
	#before_action :initialized, except: [:initialize]
	# Let's make http requests fun
	require 'HTTParty'

	# Static test
  def self.hi
    puts "Hello world!"
  end


  # autoload this somehow? must be a native way
  def initialize
  	puts "init called"
  	@config = {
  		host: 'https://securesandbox.tigo.com/',
  		endpoint: 'https://securesandbox.tigo.com/v1/',
  		merchantAccount: ENV['TIGO_MERCHANT_ACCOUNT'],
  		merchantID: ENV['TIGO_MERCHANT_ID'],
  		pin: ENV['TIGO_PIN']
  	}
  end

  # def method_name
  # end

	# 1. generate access token
  def generate_access_token
  	puts @config.inspect

  	response = HTTParty.post(
  		"#{@config[:endpoint]}oauth/generate/accesstoken?grant_type=client_credentials",
  		{ 
  			body: { client_id: 'tXdYLy51Lbk0RTNBA3COGMysh7sUmO4b',  client_secret: 'AY95V1GnHIa1TEm2' },
  			headers: { 'Content-Type' => 'application/x-www-form-urlencoded' },
  			format: :plain
  		}
  	)

  	@config[:auth] = JSON.parse response, symbolize_names: true
  	puts response
  end

  # Do paymet transaction / authorize
  # /v1/tigo/mfs/
  def payment
  	puts @config[:auth][:accessToken]

  	something = { 
			"MasterMerchant": {
				"account": @config[:merchantAccount],
				"pin": @config[:pin],
				"id": @config[:merchantID]
			},
			# "Merchant": {
			# 	"reference": "Amazon",
			# 	"fee": "23.45",
			# 	"currencyCode": "EUR"
			# },
			"Subscriber": {
				"account": "255111111111",
				"countryCode": "255",
				"country": "TZA",
				"firstName": "John",
				"lastName": "Doe",
				"emailId": "johndoe@mail.com"
			},
			"redirectUri": "https://www.ninayo.com/payment/success",
			"callbackUri": "https://www.ninayo.com/payment/callback",
			"language": "eng",
			"terminalId": "",
			"originPayment": {
				"amount": "75.00",
				"currencyCode": "USD",
				"tax": "0.00",
				"fee": "25.00"
			},
			"exchangeRate": "2182.23",
			"LocalPayment": {
				"amount": "2182.23",
				"currencyCode": "TZS"
			},
			"transactionRefId": SecureRandom.uuid().to_s
		}

		puts something

  	response = HTTParty.post(
  		"#{@config[:endpoint]}tigo/payment-auth/authorize", { 
  			body: something.to_json,
  			headers: { 
  				'Content-Type' => 'application/json',
  				'accessToken' => @config[:auth][:accessToken]
  			},
  			#format: :json
  		}  	
  	)
  	puts "~~~~~~"
  	#puts @config[:endpoint] + 'tigo/payment-auth/authorize'
  	#puts @config[:endpoint]
  	puts response
  end

  # Check if the subscriber has a valid MFS account in the designated country
  def validateMFSAccount
  	# response = HTTParty.post(
  	# 	@config[:endpoint] << 'tigo/mfs/validateMFSAccount',
  	# 	{ body: {
		 #      "transactionRefId" : "1300074238",
		 #      "ReceivingSubscriber" :
		 #      {
		 #      	"account" : "255658123964",
			# 			"countryCallingCode" : "255",
			# 			"countryCode" : "TZA",
			# 			"firstName" : "John",
			# 			"lastName" : "Doe"
		 #      }
		 #    },
		 #    headers: {
		 #    	'accessToken': @config[:auth][:accessToken]
		 #    }
			# } 
  	# )

  	puts response.inspect
  end

  # depositRemittance
  # /v1/tigo/mfs/depositRemittance
  def deposit
  end


  def status
  	response = HTTParty.get(
  		"#{@config[:endpoint]}tigo/systemstatus",
  		{
	  		headers: {
	  			'accessToken' => @config[:auth][:accessToken]
	  		}
	  	}
  	)

  	puts "STATUS: "
  	puts response
  end

  def
  end

  # reverse a transaction
  def reverse
  end

  # public CALLBACKS
  def status
  end


  private
	  # Did we initialize w/ a config?
	  def initialized
	  	return !@config.nil?
	  end
	end
end


#########################
# static testing
#########################
test = TigopesaPaymentRails.new
test.generate_access_token
test.status
test.payment
