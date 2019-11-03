import React from 'react';
import {
    View, Button,
} from 'react-native';


export default class MenuScreen extends React.Component {
    static navigationOptions = {
        title: 'Menu',
    };

    render() {
        return (
            <View
                style={{
                    flex: 1, padding: 1, alignItems: 'center',
                }}
            >
                <Button title="Option 1">Option 1</Button>
                <Button title="Option 2">Option 2</Button>
                <Button title="Option 3">Option 3</Button>
            </View>
        );
    }
}
