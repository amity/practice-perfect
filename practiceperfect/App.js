import React from 'react';
import {
    View, Button, Text,
} from 'react-native';
import { createAppContainer } from 'react-navigation';
import { createStackNavigator } from 'react-navigation-stack';
import { Header } from 'react-native-elements';
import ProfileScreen from './ProfileScreen';
import MenuScreen from './MenuScreen';

class HomeScreen extends React.Component {
    static navigationOptions = ({ navigation }) => {
        return {
            headerTitle: 'PracticePerfect',
            headerRight: (
                <Button
                    title="Profile"
                    onPress={() => navigation.navigate('Profile', { name: 'Jane' })}
                />
            ),
        };
    };

    constructor() {
        super();
        this.state = {
            currentIndex: 0,
            currentProfileIndex: 0,
            showBio: false,
        };
    }

    render() {
        const { navigate } = this.props.navigation;
        return (
            <View style={{ flex: 1 }}>
                <Header
                    leftComponent={{ icon: 'menu', color: '#fff', onPress: () => navigate('Menu') }}
                    centerComponent={{ text: 'PracticePerfect', style: { color: '#fff', fontSize: 20 } }}
                    rightComponent={(
                        <Button
                            title="Profile"
                            color="#fff"
                            onPress={() => navigate('Profile')}
                        />
                    )}
                    backgroundColor="#e75480"
                />
                <Text style={{ flex: 1 }}>
                    Hello World!
                </Text>
                <View style={{ height: 60 }} />
            </View>
        );
    }
}

const MainNavigator = createStackNavigator({
    Home: {
        screen: HomeScreen,
        navigationOptions: { header: null },
    },
    Profile: { screen: ProfileScreen },
    Menu: { screen: MenuScreen },
});
const App = createAppContainer(MainNavigator);
export default App;
