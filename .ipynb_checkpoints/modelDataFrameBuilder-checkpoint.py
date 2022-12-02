"""
MyCode Package
-----------------------------------------------------
This is the python file that merges the three dataframes, cleans them, and creates fields for our model. 

"""

# Importing Required Libraries:
import pandas as pd
import numpy as np

#Function to get Game Outcome:
def Outcome(df):
    """
    :param name: df - Dataframe for which to get the Game Outcome for
    :param type: pandas dataframe
    :return: the winning team name from the column 'team1' or 'team2', depending on which team won. If a tie, return tie. If anything else, return 'NA'.
    """
    if (df['score1'] > df['score2']):
        return df['team1']
    elif (df['score2'] > df['score1']):
        return df['team2']
    elif (df['score2'] == df['score1']):
        return 'Tie'
    else:
        return "NA"
        
#Function to get Game Outcome Prediction Based on Our Model:
def ModelOutcome(df):
    """
    :param name: df - Dataframe for which to get the Game Outcome Prediction based on our model
    :param type: pandas dataframe
    :return: the winning team name from the column 'home_team' or 'away_team', depending on which team has higher win probability. If a tie, return tie. If anything else, return 'NA'.
    """
    if (df['model_home_wp'] > df['model_away_wp']):
        return df['home_team']
    elif (df['model_away_wp'] > df['model_home_wp']):
        return df['away_team']
    elif (df['model_away_wp'] == df['model_home_wp']):
        return 'Tie'
    else:
        return "NA"

#Main Function
def main():
    """
    :param name: none
    :return: output the final dataframe in csv format to be implemented in the front-end UI
    """
    # Reading in Datasets:
    FiveThirtyEight = pd.read_csv("FiveThirtyEight.csv", index_col = 0)
    ESPN = pd.read_csv("ESPN_PastData.csv", index_col = 0)

    #Data Cleaning: removing unnecessary columns from the dataframes, removing unused old data, and removing bad rows (with no win probability):

    #Converting Datatypes of Columns:
    FiveThirtyEight.astype({'season': 'int32', 'fivethirtyeight_home_wp': 'float'})
    ESPN.astype({'season': 'int32', 'winpb_home': 'float', 'winpb_away': 'float'})
    FiveThirtyEight['date'] = pd.to_datetime(FiveThirtyEight['date'])
    ESPN['game_date'] = pd.to_datetime(ESPN['game_date'])

    #Adding in Columns for Year, Month, Day:
    ESPN['year'], ESPN['month'], ESPN['day'] = ESPN['game_date'].dt.year, ESPN['game_date'].dt.month, ESPN['game_date'].dt.day
    FiveThirtyEight['year'], FiveThirtyEight['month'], FiveThirtyEight['day'] = FiveThirtyEight['date'].dt.year, FiveThirtyEight['date'].dt.month, FiveThirtyEight['date'].dt.day

    #Filtering 538 to only include data of past 5 seasons:
    options = [2018,2019,2020,2021,2022,2023] 
    FiveThirtyEight = FiveThirtyEight.loc[FiveThirtyEight['season'].isin(options)] 

    #Renaming Columns:
    FiveThirtyEight = FiveThirtyEight.rename(columns={"team1": "home_team", "team2": "away_team", 'fivethirtyeight_home_wp' : "538_home_wp"})
    ESPN = ESPN.rename(columns={"home_team_abb": "home_team", "away_team_abb": "away_team", "winpb_home": "ESPN_home_wp", "winpb_away": "ESPN_away_wp"})

    #Adding Column to 538 Data for away win probabilities:
    FiveThirtyEight['538_away_wp'] = 1 - FiveThirtyEight['538_home_wp']

    #Converting date column to be in same format as 538 data:
    ESPN['date'] = pd.to_datetime(ESPN["game_date"].dt.strftime('%Y-%m-%d'))

    #Removing unnecessary columns:
    ESPN = ESPN[['date', 'season', 'home_team', 'away_team', 'ESPN_home_wp', 'ESPN_away_wp']]
    FiveThirtyEight = FiveThirtyEight[['date', 'season', 'home_team', 'away_team', '538_home_wp', '538_away_wp']]

    #Changing Team Names to Match Between Two Dataframes:
    teams_dict = {'CHA' : 'CHO', 'PHX' : 'PHO', 'BKN' : 'BRK', 'GS' : 'GSW', 'UTAH' : 'UTA', 'NO' : 'NOP', 'WSH' : 'WAS', 'NY' : 'NYK', 'SA' : 'SAS'}
    ESPN = ESPN.replace({'home_team' : teams_dict})
    ESPN = ESPN.replace({'away_team': teams_dict})
    FiveThirtyEight = FiveThirtyEight.replace({'home_team' : teams_dict})
    FiveThirtyEight = FiveThirtyEight.replace({'away_team': teams_dict})

    #Reading in Future ESPN Data:
    ESPNFuture = pd.read_csv("ESPN_CurrentGamesWeek.csv", index_col = 0)
    ESPNFuture['date'] = pd.to_datetime(ESPNFuture['date'])
    ESPNFuture.astype({'season': 'int32', 'wp_home': 'float', 'wp_away': 'float'})
    ESPNFuture = ESPNFuture.rename(columns={"home_team_abb": "home_team", "away_team_abb": "away_team", "wp_home": "ESPN_home_wp", "wp_away": "ESPN_away_wp"})
    teams_dict = {'CHA' : 'CHO', 'PHX' : 'PHO', 'BKN' : 'BRK', 'GS' : 'GSW', 'UTAH' : 'UTA', 'NO' : 'NOP', 'WSH' : 'WAS', 'NY' : 'NYK', 'SA' : 'SAS'}
    ESPNFuture = ESPNFuture.replace({'home_team' : teams_dict})
    ESPNFuture = ESPNFuture.replace({'away_team': teams_dict})
    ESPNFuture = ESPNFuture[['date', 'season', 'home_team', 'away_team', 'ESPN_home_wp', 'ESPN_away_wp']]

    #Combining Future ESPN Data with ESPN Past Data:
    ESPN = ESPN.append(ESPNFuture)

    # Filtering out bad data from ESPN:
    ESPN = ESPN[ESPN['ESPN_home_wp'] != -1] 

    #New Dataframe that appends two datasets:
    combined = pd.merge(ESPN, FiveThirtyEight, on=['date', 'season', 'home_team', 'away_team'])

    #New Columns for Our Model's win probabilities:
    combined['model_home_wp'] = (combined['ESPN_home_wp'] + combined['538_home_wp'])/2
    combined['model_away_wp'] = (combined['ESPN_away_wp'] + combined['538_away_wp'])/2

    #Adding in Game Outcomes
    FiveThirtyEightOriginalData = pd.read_csv("https://projects.fivethirtyeight.com/nba-model/nba_elo.csv")
    FiveThirtyEightOriginalData['Outcome'] = FiveThirtyEightOriginalData.apply(Outcome, axis = 1)
    FiveThirtyEightOriginalData = FiveThirtyEightOriginalData[['date', 'season', 'team1', 'team2', 'Outcome']]
    FiveThirtyEightOriginalData = FiveThirtyEightOriginalData.rename(columns={"team1": "home_team", "team2": "away_team"})
    FiveThirtyEightOriginalData['date'] = pd.to_datetime(FiveThirtyEightOriginalData['date'])
    combined = pd.merge(combined, FiveThirtyEightOriginalData, on=['date', 'season', 'home_team', 'away_team'])

    #Adding in Game Outcome Predictions and Accuracy Columns:
    combined['ModelPredOutcome'] = combined.apply(ModelOutcome, axis = 1)
    combined['Accurate?'] = combined['Outcome'] == combined['ModelPredOutcome']

    #Writing dataframe to csv file:
    combined.to_csv("finalDataframe.csv", index = False)

if __name__ == "__main__":
    main()