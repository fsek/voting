Agenda.find_or_create_by!(index: 1, title: 'SOFMÖ - sektionsordförande förklarar mötet öppnat')
Agenda.find_or_create_by!(index: 2, title: 'Tid och sätt för mötet')
Agenda.find_or_create_by!(index: 3, title: 'Val av justerare tillika rösträknare tillika omfamnare')
Agenda.find_or_create_by!(index: 4, title: 'Justering av röstlängden')
Agenda.find_or_create_by!(index: 5, title: 'Adjungeringar')
Agenda.find_or_create_by!(index: 6, title: 'Val av mötesordförande')
Agenda.find_or_create_by!(index: 7, title: 'Val av mötessekreterare')
Agenda.find_or_create_by!(index: 8, title: 'Mötesinformation')
Agenda.find_or_create_by!(index: 9, title: 'Godkännande av föredragningslista')
Agenda.find_or_create_by!(index: 10, title: 'Meddelanden')
Agenda.find_or_create_by!(index: 11, title: "Styrelsens verksamhetsberättelse för #{Time.zone.now.year}")
Agenda.find_or_create_by!(index: 12, title: "Likabehandlingsutskottets preliminära verksamhetsberättelse för #{Time.zone.now.year}")

# Propositions
prop = Agenda.find_or_create_by!(index: 13, title: 'Propositioner')
Agenda.find_or_create_by!(index: 1, title: 'First', parent: prop)
Agenda.find_or_create_by!(index: 2, title: 'Second', parent: prop)
Agenda.find_or_create_by!(index: 3, title: 'Third', parent: prop)
Agenda.find_or_create_by!(index: 4, title: 'Fourth', parent: prop)

# Motions
motion = Agenda.find_or_create_by!(index: 14, title: 'Motioner')
Agenda.find_or_create_by!(index: 1, title: 'First', parent: motion)
Agenda.find_or_create_by!(index: 2, title: 'Second', parent: motion)
Agenda.find_or_create_by!(index: 3, title: 'Third', parent: motion)
Agenda.find_or_create_by!(index: 4, title: 'Fourth', parent: motion)

# Posts
posts = Agenda.find_or_create_by!(index: 15, title: 'Funktionärsval')
Agenda.find_or_create_by!(index: 1, title: 'First', parent: posts)
Agenda.find_or_create_by!(index: 2, title: 'Second', parent: posts)
Agenda.find_or_create_by!(index: 3, title: 'Third', parent: posts)
Agenda.find_or_create_by!(index: 4, title: 'Fourth', parent: posts)

Agenda.find_or_create_by!(index: 16, title: 'Övriga frågor')
Agenda.find_or_create_by!(index: 17, title: 'Frågan om F´s förträfflighet')
Agenda.find_or_create_by!(index: 18, title: 'Mötesordförandes fräckis')
Agenda.find_or_create_by!(index: 19, title: 'MOFMA - mötesordförande förklarar mötet avslutat')

# Menu
Menu.find_or_create_by!(name: 'Om', location: Menu::INFO, link: '/om', index: 10, visible: true)
Menu.find_or_create_by!(name: 'Dokument', location: Menu::INFO, link: '/dokument', index: 20, visible: true)
Menu.find_or_create_by!(name: 'Användarvillkor', location: Menu::INFO, link: '/villkor', index: 30, visible: true)
