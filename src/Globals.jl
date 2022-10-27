module Globals
	export INDEX_TO_TILE, TILE_TO_INDEX, INDEX_TO_PAIR, PAIR_TO_INDEX
	"""
	Creates a dictionary with the index of the board (1-64) as the key and the corresponding
	tile (i.e. a8, h1) as the values
	"""
	# function create_index_to_tile_mapping()

	# 	d = Dict{Int,String}()
	# 	letters = ['a','b','c','d','e','f','g','h']
	# 	row = 8
	# 	i = 1
	# 	while true
	# 		if i > 64
	# 			break
	# 		end
	# 		for letter in letters
	# 			pos = string(letter,row)
	# 			d[i] = pos
	# 			i+= 1
	# 		end
	# 		row -=1
	# 	end
	# 	return d
	# end

	function create_index_to_tile_mapping()
		d = Dict{Int,String}()
		letters = ['a','b','c','d','e','f','g','h']
		start = 1
		fin = 8
		j = 1
		for letter in letters
			for i in start:fin 
				pos = string(letter,j)
				d[i] = pos
				j+=1
			end
			start += 8
			fin += 8
			j = 1
		end
		return d

	end

	"""
	Creates a dicitonary with the tile (i.e. a8, h1) as the key and the index of the board (1-64) 
	as the values
	"""
	# function create_tile_to_index_mapping()
	# 	d = Dict{String,Int}()
	# 	letters = ['a','b','c','d','e','f','g','h']
	# 	row = 8
	# 	i = 1
	# 	while true
	# 		if i > 64
	# 			break
	# 		end
	# 		for letter in letters
	# 			pos = string(letter,row)
	# 			d[pos] = i
	# 			i+= 1
	# 		end
	# 		row -=1
	# 	end
	# 	return d

	# end
	function create_tile_to_index_mapping()
		d = Dict{String,Int}()
		letters = ['a','b','c','d','e','f','g','h']
		start = 1
		fin = 8
		j = 1
		for letter in letters
			for i in start:fin 
				pos = string(letter,j)
				d[pos] = i
				j+=1
			end
			start += 8
			fin += 8
			j = 1
		end
		return d

	end

	"""
	Maps a single index to the the [row,column] index in a julia multidimensional array
	"""
	function create_single_to_double_mapping() 
		d = Dict{Int,Tuple{Int,Int}}()
		letters = ['a','b','c','d','e','f','g','h']
		start = 1
		fin = 8
		j = 1
		for (col,letter) in enumerate(letters)
			for i in start:fin
				# pos = string(letter,j)
				row_col = (j,col)
				
				d[i] = row_col
				j+=1
			end
			start += 8
			fin += 8
			j = 1
		end
		return d
	end


	function create_double_to_single_mapping()
		d = Dict{Tuple{Int,Int},Int}()
		letters = ['a','b','c','d','e','f','g','h']
		start = 1
		fin = 8
		j = 1
		for (col,letter) in enumerate(letters)
			for i in start:fin
				# pos = string(letter,j)
				row_col = (j,col)

				d[row_col] = i
				
				j+=1
			end
			start += 8
			fin += 8
			j = 1
		end
		return d
	end






	const INDEX_TO_TILE = create_index_to_tile_mapping() ## used as a global for fast lookup
	const TILE_TO_INDEX = create_tile_to_index_mapping() ## used as a global for fast lookup
	const INDEX_TO_PAIR = create_single_to_double_mapping() ## used as a global for fast lookup
	const PAIR_TO_INDEX = create_double_to_single_mapping() ## used a global for fast lookup


end ## end module