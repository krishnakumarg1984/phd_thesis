from wordcloud import WordCloud
import matplotlib.pyplot as plt

def text():
    with open('STATS.words') as f:
        alltext = ''
        for line in f:
            count, word = line.strip().split(' ')
            alltext += int(count) * (word + ' ')
        return alltext

def main():
    alltext = text()

    wordcloud = WordCloud(
        width=1200,
        height=600,
        margin=0,
        max_words=100000,
        collocations=False,
        background_color=None,
        mode='RGBA').generate(alltext).to_file('cloud.png')

if __name__ == '__main__':
    main()
