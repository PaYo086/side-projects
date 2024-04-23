import requests
from bs4 import BeautifulSoup
import time
t = 0.5

# get paper url by keyword
def geturl(keyword, pages):
    paper_url = {}
    for i in range(1, pages+1):
        page_num = i
        r = requests.get('https://www.nature.com/search?q=%s&page=%s' % (keyword, page_num))
        html = r.content.decode('utf-8')
        soup = BeautifulSoup(html, 'html.parser')

        results = soup.find_all(lambda tag: tag.name == 'div' and tag.get('class') == ['cleared'])

        url = []
        for j in range(1, len(results)):
            url.append(results[j].find('a')['href'])
        
        paper_url[str(i)] = url
        time.sleep(t)
    return paper_url

# get abstracts, titles, authors, dates, journals
def getcontent(paper_url, pages):
    paper_abstract = {}; paper_title= {}; paper_author = {}; paper_date = {}; paper_journal = {}
    for i in range(1, pages+1):
        abstract = []; title = []; author = []; date = []; journal = []
        for j in paper_url[str(i)]:
            print('https://www.nature.com%s' % j)
            r = requests.get('https://www.nature.com%s' % j)
            html = r.content.decode('utf-8')
            soup = BeautifulSoup(html, 'html.parser')

            abstract.append(soup.find('meta', {'name':'dc.description'})['content'])
            title.append(soup.find('meta', {'name':'dc.title'})['content'])

            author_tag = soup.find_all('meta', {'name':'dc.creator'})
            author_temp = []
            for k in author_tag:
                author_temp.append(k['content'])
            author.append(author_temp)

            # date.append(soup.find('meta', {'name':'prism.publicationDate'})['content'])
            date_temp = str(soup.find('script', {'data-test':'dataLayer'}))
            date_post = date_temp.find('publishedAtString')+20
            date.append(date_temp[date_post:date_post+10])

            journal.append(soup.find('meta', {'name':'prism.publicationName'})['content'])
            time.sleep(t)
        
        paper_abstract[str(i)] = abstract; paper_title[str(i)] = title; paper_author[str(i)] = author
        paper_date[str(i)] = date; paper_journal[str(i)] = journal
    return paper_abstract, paper_title, paper_author, paper_date, paper_journal

# make html
def makeHTML(keyword, pages, paper_url, paper_abstract, paper_title, paper_author, paper_date, paper_journal):
    # keyword
    head = '''
<!DOCTYPE HTML>
<html>
    <head>
        <meta charset="utf-8">
        <title>Nature, Keyword: %s</title>
    </head>
    <body>
    ''' % keyword
    # url, title, authors, journal, date, abstract
    template = '''
        <div>
            <h1><a href="https://www.nature.com%s" target="_blank" style="color:black; text-decoration:none">%s</a></h1>
            <p>%s</p>
            <pre style="font-family:timesnewroman">Journal: %s    Published: %s</pre>
            <h2>Abstract</h2>
            <font size="4">%s</font>
        </div>
        <br><hr>
    '''
    end = '''
    </body>
</html>
    '''
    content = ''
    for h in range(1, pages+1):
        for i in range(len(paper_url[str(h)])):
            content += template % (paper_url[str(h)][i], paper_title[str(h)][i], ', '.join(paper_author[str(h)][i]), paper_journal[str(h)][i], paper_date[str(h)][i], paper_abstract[str(h)][i])

    with open('%s.html' % keyword, mode = 'w', encoding='utf-8') as f:
        f.write(head + content + end + '\n')

def main():
    keyword = input('Keyword: ').strip()
    pages = int(input('Number of pages: '))

    paper_url = geturl(keyword, pages)
    paper_abstract, paper_title, paper_author, paper_date, paper_journal = getcontent(paper_url, pages)

    makeHTML(keyword, pages, paper_url, paper_abstract, paper_title, paper_author, paper_date, paper_journal)

main()