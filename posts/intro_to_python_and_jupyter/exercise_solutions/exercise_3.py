import requests as r

def get_compound_data_by_name(compound_name):
	response = r.get("https://www.npatlas.org/api/v1/compounds/full/?name="+compound_name)
	return response.json()[0]

compound_list = ['Lincomycin','Collismycin A','Streptomycin','Erythromycin B']
for compound in compound_list:
	try:
		compound_data = get_compound_data_by_name(compound)
		print(compound_data['original_name'],"is produced by",compound_data['origin_organism']['genus'],"and has a molecular weight of",compound_data['mol_weight'],"Da.")
	except:
		print(compound,"was not found in the NPAtlas database.")