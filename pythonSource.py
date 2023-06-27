#creates link for NBA API
def getNBAName(nameHolder):
  linkFirst = "/players/"
  linkNum = "01"
  linkExt = ".html"
  
  #gets name & removes space
  pName = nameHolder
  if " " not in pName:
    return "None"
  
  else:
    pNameHold = pName.replace(" ","")
  #seperator to get string of last name (seperate at space)
    sep = " "
    abvLastHold = pName.split(sep, 1)[1]
    abvLast = abvLastHold[:5].lower()
  
  #gets first 2 letters of first name for API link
    abvFirst = pNameHold[:2].lower()
  
  #get first letter of last name (for link)
    firstLetterLastHold = pName.split(sep, 1)[1]
    firstLetterLast = firstLetterLastHold[:1].lower()
  
  #concatinates string to be used for API link
    apiLink = linkFirst+firstLetterLast+"/"+abvLast+abvFirst+linkNum+linkExt

    return apiLink
  
  
