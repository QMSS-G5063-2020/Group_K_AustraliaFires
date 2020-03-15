# -*- coding: utf-8 -*-
"""
Created on Sat Oct  5 13:05:36 2019

@author: pathouli
"""

class crawler(object):

#Crawls the top ~50 URLs and retrieves non html text
    def my_scraper(self, tmp_url_in):
        from bs4 import BeautifulSoup
        import requests
        import re
        tmp_text = ''
        
        content = requests.get(tmp_url_in)
        soup = BeautifulSoup(content.text, 'html.parser')
    
        tmp_text = soup.findAll('p') 
    
        tmp_text = [word.text for word in tmp_text]
        tmp_text = ' '.join(tmp_text)
        tmp_text = re.sub('\W+', ' ', re.sub('xa0', ' ', tmp_text))
        try:
            for i in soup.findAll('time'):
                #print('hello')
                if i.has_attr('datetime'):
                    time = (i['datetime'])
                else:
                    time =  -1
            return (tmp_text, time)
        except:
            return (tmp_text, -1)
        #print(tmp_text, time)
        
        
    
        

# Fetches the top ~50 sites, URLs, from a google search:
    def fetch_urls(self, query_tmp, cnt):
        #now lets use the following function that returns
        #URLs from an arbitrary regex crawl form google
    
        #pip install pyyaml ua-parser user-agents fake-useragent
        import requests
        from fake_useragent import UserAgent
        from bs4 import BeautifulSoup
        import re 
        ua = UserAgent()
    
        # print(query_tmp)
        query = '+'.join(query_tmp.split())
        google_url = "https://www.google.com/search?q=" + query + "&num=" + str(cnt)
        print (google_url)
        response = requests.get(google_url, {"User-Agent": ua.random})
        soup = BeautifulSoup(response.text, "html.parser")

        result_div = soup.find_all('div', attrs = {'class': 'ZINbbc'})

        links = []
        titles = []
        descriptions = []
        for r in result_div:
            # Checks if each element is present, else, raise exception
            try:
                link = r.find('a', href = True)
                title = r.find('div', attrs={'class':'vvjwJb'}).get_text()
                description = r.find('div', attrs={'class':'s3v9rd'}).get_text()
    
                # Check to make sure everything is present before appending
                if link != '' and title != '' and description != '': 
                    links.append(link['href'])
                    titles.append(title)
                    descriptions.append(description)
            # Next loop if one element is not present
            except:
                continue  
    
        to_remove = []
        clean_links = []
        for i, l in enumerate(links):
            clean = re.search('\/url\?q\=(.*)\&sa',l)
    
            # Anything that doesn't fit the above pattern will be removed
            if clean is None:
                to_remove.append(i)
                continue
            clean_links.append(clean.group(1))

        return clean_links
 
# Writes the cleaned text from the ~50 crawls to a location specified by my_path on your hard drive
    def write_crawl_results(self, the_path, my_query, the_cnt_in):
        #let use fetch_urls to get URLs then pass to the my_scraper function 
        import os
        import re
        import pandas as pd
        from nltk.stem import PorterStemmer
        
        the_urls_list = self.fetch_urls(my_query, the_cnt_in)
        try:
            os.makedirs(the_path + re.sub('[ ]+', '_', re.sub('"', '', my_query)))
        except:
            pass

        the_data = pd.DataFrame(columns = ['body_basic', 'time'])
        #full_list = {}
        #full_data = pd.DataFrame(columns = ['body_basic', 'body_stem', 'label'])
        cnt = 0
        for word in the_urls_list:
            tmp_txt, time = self.my_scraper(word) # Scrapes the text from the URLs obtained
            #print(temp)
            #tmp_txt = temp[0]
            #time = temp[1]
            # print(tmp_txt)
            #print(time)
            if len(tmp_txt) != 0: # If the text exists (length != 0), then save the file as...
                try:
                    
                    the_data = the_data.append({'body_basic':tmp_txt, 'time': time}, ignore_index=True)
                    
                    print(the_data)
                    
                    cnt += 1
                except:
                    pass
        the_data.to_csv(the_path + re.sub('"', '', '_'.join(my_query.split(' '))) + '/' + "the_data.csv", index=False)