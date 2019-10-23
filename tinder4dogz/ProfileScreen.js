import React from 'react';
import {
    ScrollView, View, Image,
} from 'react-native';
import { Hoshi } from 'react-native-textinput-effects';

const pic8 = require('./assets/propic.jpg');


export default class ProfileScreen extends React.Component {
    static navigationOptions = {
        title: 'Profile',
    };

    render() {
        return (
            <View
                style={{
                    flex: 1, padding: 1, alignItems: 'center',
                }}
            >
                <ScrollView>
                    <Image
                        style={{
                            flex: 1, height: 200, width: 200, resizeMode: 'cover', borderRadius: 20,
                        }}
                        source={pic8}
                    />
                    <Hoshi
                        label="Name"
                        borderColor="#e75480"
                        borderHeight={3}
                    />
                    <Hoshi
                        label={'Dog(s\') Name(s)'}
                        borderColor="#e75480"
                        borderHeight={3}
                    />
                    <Hoshi
                        label="Neighborhood"
                        borderColor="#e75480"
                        borderHeight={3}
                    />
                    <Hoshi
                        label="Desired Distance"
                        borderColor="#e75480"
                        borderHeight={3}
                    />
                </ScrollView>
            </View>
        );
    }
}
