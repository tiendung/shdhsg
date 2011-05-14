%w[Aen JoonIan mengwong bleongcw jpaine mattrigbye nazroll erickohsg jfxberns cerventus korffr hchoroomi yaoquan niamutiara isnav bearwithclaws mohit_a calvinchengx Espen_Antonsen echoz honcheng danielgoh xobs ozziegooen hyperair vikramverma skalifowitz ronnieliew kates meaningful arulprasad tiendung rifchia dinhhai donsdai tmsil1 sayanee_ usmansheikh zackyap gunjankarun  yongfook  bhoga deschutz kienwai mbrochh asciicode willyang77 kamal wizztjh amin_wi shichuan iamclovin melissalim shinchi entinomy oh_my_natalie vinothgopi tardate kosherjellyfish jasonong vlauria skinnylatte riverplatevn].each do |shdhsg_attendee_twitter_id|
  u = User.new(:twitter_id => shdhsg_attendee_twitter_id)
  u.save(:validate => false)
end
