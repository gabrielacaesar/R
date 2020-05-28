# importing libraries
import pandas as pd
import requests
from bs4 import BeautifulSoup

url = "https://www.camara.leg.br/presenca-comissoes/votacao-portal?reuniao=59588"

page = requests.get(url)

html = page.content

soup = BeautifulSoup(html, 'html.parser')


nomes = soup.find(name='span', attrs={'class':'nome'})

for nome in nomes:
    print(nomes.text)


all_voto_deputado = soup.find_all(name='span', attrs={'class':'votou'})

all_partido_deputado = soup.find_all(name='span', attrs={'class':'nomePartido'})
