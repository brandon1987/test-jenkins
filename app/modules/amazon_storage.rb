module AmazonStorage

	def saveAmazonFile(folder,filename,filedata)  #Save a new file to the cloud storage for this company
		s3 = getS3()
		bucket = s3.buckets["storage.constructionmanager.net"]
		foldername="#{Rails.env}#{session[:company_id]}/#{folder}#{filename}"
		object = bucket.objects.create(foldername, filedata)
		return object.exists?
	end

	def deleteAmazonFile(folder,filename)		#Delete a specified file from company's cloud storage
		s3 = getS3()
		bucket     = s3.buckets["storage.constructionmanager.net"]
		puts "AMAZON DELETE #{Rails.env}#{session[:company_id]}/#{folder}#{filename}"
		foldername = "#{Rails.env}#{session[:company_id]}/#{folder}#{filename}"
		object     = bucket.objects[foldername]
		object.delete

		return !object.exists?
	end

	def deleteAmazonFolder(folder)
		#untested
		filearray = Array.new
		s3 = getS3()
		bucket = s3.buckets["storage.constructionmanager.net"]
		foldername="#{Rails.env}#{session[:company_id]}#{folder}"
		files = bucket.objects.with_prefix(foldername).each do |file|
			file.delete
		end

	end

	def renameAmazonFolder(folder,newname)
		completenewname="#{Rails.env}#{session[:company_id]}#{newname}"
		completeoldname="#{Rails.env}#{session[:company_id]}#{folder}"
		bsize = completenewname.size
		s3 = getS3()
		bucket = s3.buckets["storage.constructionmanager.net"]
		bucket.objects.with_prefix(completeoldname).each do |o|
			puts o.key
			puts "change to"<<completenewname + o.key[bsize..-1]
		    o.move_to( completenewname + o.key[bsize..-1])
		end



	end


	def createAmazonFolder(foldername)
		s3 = getS3()
		bucket = s3.buckets["storage.constructionmanager.net"]

		foldername="#{Rails.env}#{session[:company_id]}#{foldername}/"#_$folder$
		object = bucket.objects.create(foldername, '')
		return object.exists?
	end

	def folderExistsInS3(foldername)
		#untested
		s3 = getS3()
		bucket = s3.buckets["storage.constructionmanager.net"]
		return bucket.objects.with_prefix("#{Rails.env}#{session[:company_id]}/#{foldername}").any?
	
	end

	def getAmazonFolderStructure(folder)
		filearray = Array.new
		s3 = getS3()
		bucket = s3.buckets["storage.constructionmanager.net"]
		foldername="#{Rails.env}#{session[:company_id]}/#{folder}"

		files = bucket.objects.with_prefix(foldername).each do |file|
			filearray<<file.key[foldername.length+1,file.key.length]
		end

		folderstructure=S3Folder.new("/")

		filearray.each do |file|
			file<<"¬" if file[-1]!="/" #this is a folder
			splitpath=file.split("/")
			folderstructure.addPath(splitpath)
		end

		return folderstructure
	end




	def getAmazonFile(folder,filename)
		puts "check for "<<"#{Rails.env}#{session[:company_id]}/#{folder}#{filename}"
		s3 = getS3()
		bucket = s3.buckets["storage.constructionmanager.net"]
		fileobj = bucket.objects["#{Rails.env}#{session[:company_id]}/#{folder}#{filename}"]
		return fileobj.read
	end



	def getAmazonFileList(folder)				#Return an array of the file in this cloud folder

		filearray = Array.new
		s3 = getS3()
		bucket = s3.buckets["storage.constructionmanager.net"]
		foldername="#{Rails.env}#{session[:company_id]}/#{folder}"

		files = bucket.objects.with_prefix(foldername).each do |file|
			filename=file.key[foldername.length+1,file.key.length]
			filearray<<S3File.new(filename,file.last_modified,file.content_length) if file.content_length!=0 && !filename.include?("/")
		end
		return filearray.to_json
	end

	class S3File
	  def initialize(filename, lastmodified,filesize)
	    @filename = filename
	    @lastmodified = datetime_format(lastmodified)
	    @filesize = Filesize.from(filesize.to_s<<" B").pretty
	  end
	end


	class S3Folder
		def initialize(foldername)
			@name=foldername
			@subfolders=[]
		end
		def name
			return @name
		end
		def getsubfolders()
			return @subfolders
		end
		def addPath(splits)
			bDone=false
			if splits.length !=0
				currentsplit=splits.shift
				#find existings
				@subfolders.each do |subfolder|
					if subfolder.name==currentsplit
						subfolder.addPath(splits)
						bDone=true
					end
				end

				#process new ones
				if currentsplit[-1]=="¬"
					#this is a file terminator, so do not add a stub
				else
					if !bDone
						newsubfolder=S3Folder.new(currentsplit)
						@subfolders<<newsubfolder
						newsubfolder.addPath(splits)
					end
				end
			else
			#no more items to process so do nothing
			end
		end
	end


	def getS3()
		return AWS::S3.new(:access_key_id => Rails.application.secrets['aws_id'],:secret_access_key => Rails.application.secrets['aws_key'])
	end

end
