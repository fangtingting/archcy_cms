# rails2:script/rails runner script/test.rb
# rails3以上：rails runner bin/test.rb
wechat=QyWechat.new
options={:id => "1238"}
puts wechat.op_contacts("department","list",options)

wechat=QyWechat.new
wechat.apply_token = 'CYnThmqmahR'
wechat.encoding_aes_key = 'HGm36taLqNBvwLaJAMLGY8HNE2kQxyK4wQaPBzYEjdj'
puts wechat.verify_url("b9b1310b0e6f5ebd07e25be21669092dbebccd7a","1472189614","1808407466","Y95KLBXrN+LAqoEHdzfI+D+Y8tqqDXhOv5/nrlBJh3XXzBzMczfO1krOtd/S7Ah0WnYEbkgFvFjLk8o8RW2rQ/ILbngvWJNTe3gLjqzOq4DJ2DuI3iTNIZZenI8PQtEsz0D3AWuPKAR4f1/uyRMI1Zber4UHlvo37Oo2RAfcwKylyNvlbIdLZzlq3HOJ3YP0TxdzFihDldJHqRxrEqnQciK6RHlC2IHcir0eqCMi1Ewdw+KpTu2ZEZpBd2K9lIBYd5H7TglS8Htt9xtncETwXUJo4958kT1TjtipAE78HMzTUIeSS4xDXfgSovS/5ddx44/Ql45hzzmMAsFrnchoULqIrMhI/WHzmcAATbP4sfWVaNvSvv0L3eerPupWEYdMmp/W7Ecpd3HNzZeqzmYt/VFV7/HidXt612rgNjKyvOA6vllPRofwqhJQ8Xe5MGO9FdRXq7RC7AlQ9Us4SVZi3w==")